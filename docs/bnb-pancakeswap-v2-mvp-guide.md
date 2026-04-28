# BNB Chain 기반 PancakeSwap V2 모델 DEX MVP 가이드

> 목적: BNB Chain(EVM)에서 PancakeSwap V2와 같은 AMM(`x*y=k`) 구조를 빠르게 구축하기 위한 최소 구현 체크리스트.

## 1) 범위 정의(MVP)

- Swap (토큰↔토큰, BNB↔토큰)
- LP 추가/제거
- Factory/Pair/Router 3계층
- 슬리피지/데드라인 보호
- 테스트넷 배포 및 기본 보안 점검

## 2) 권장 컨트랙트 구조

```
contracts/
  interfaces/
    IPancakeFactory.sol
    IPancakePair.sol
    IPancakeRouter02.sol
    IWBNB.sol
  core/
    PancakeFactory.sol
    PancakePair.sol
  periphery/
    PancakeRouter.sol
  libraries/
    Math.sol
    UQ112x112.sol
    PancakeLibrary.sol
```

### Factory

- `createPair(tokenA, tokenB)`
- `getPair[token0][token1]` 매핑
- `allPairs` 배열

### Pair

- `mint(to)` / `burn(to)`
- `swap(amount0Out, amount1Out, to, data)`
- `reserve0/reserve1` 갱신
- 0.25% 수수료(예시) 반영

### Router

- `addLiquidity(...)`
- `removeLiquidity(...)`
- `swapExactTokensForTokens(...)`
- `swapExactETHForTokens(...)` (BNB 입력)
- `swapExactTokensForETH(...)` (BNB 출력)

## 3) BNB Chain 구현 포인트

- 네이티브 BNB 직접 처리 대신 **WBNB 래핑 경로**를 기본 채택
- 경로 라우팅 예시: `TOKEN_A -> WBNB -> TOKEN_B`
- `deadline` 만료 체크와 `amountOutMin` 강제

## 4) 수수료 정책(초기 권장)

- 총 0.25%
  - MVP: 전체를 LP 보상으로 단순화
  - 추후: 프로토콜 분배(재무/소각/인센티브) 추가

## 5) 보안 체크리스트

- Reentrancy 방지
- 슬리피지/데드라인 강제
- 페어 정렬(`token0 < token1`) 일관성
- `k` 불변식 훼손 여부 테스트
- Fee-on-transfer 토큰 대응 정책 명시
- 감사 전 메인넷 배포 금지

## 6) 테스트 항목(필수)

- 유동성 추가/제거 시 LP 토큰 수량 검증
- 단일 홉/다중 홉 스왑 결과 검증
- 슬리피지 실패 케이스
- 만료 거래(`deadline`) 실패 케이스
- 저유동성 상태에서 가격 영향 테스트

## 7) 배포 순서

1. 테스트 토큰 2~3개 배포
2. Factory 배포
3. Router 배포(Factory, WBNB 주소 주입)
4. 초기 페어 생성 + 시드 유동성
5. 프론트엔드에서 approve/swap/add/remove 연결
6. BNB Chain Testnet 시나리오 리허설

## 8) 프론트엔드 최소 화면

- 지갑 연결(BNB Chain network switch 포함)
- Swap: 입력/출력 토큰 선택, 슬리피지 설정
- Pool: Add/Remove Liquidity
- 트랜잭션 상태(대기/성공/실패) 표시

## 9) 개발 스택 권장

- Solidity + Foundry
- OpenZeppelin(ERC20, Ownable, ReentrancyGuard)
- Next.js + wagmi + viem
- 테스트넷 우선 배포 후 메인넷 전환

## 10) 운영 시 주의

- MEV(샌드위치) 리스크 안내
- 대규모 거래 경고 UX
- 모니터링: 실패율, 슬리피지 초과, 유동성 급감 알림

---

이 문서는 MVP 가이드이며, 실제 상용 배포 전에는 코드 감사, 비상정지 정책, 운영 키 관리, 법적 컴플라이언스 검토가 필요합니다.
