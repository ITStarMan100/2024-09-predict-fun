// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {IPredictDotLoan} from "../../contracts/interfaces/IPredictDotLoan.sol";

import {PredictDotLoan_Test} from "./PredictDotLoan.t.sol";
import {MockUmaCtfAdapter} from "../mock/MockUmaCtfAdapter.sol";

contract PredictDotLoan_AcceptBorrowRequest_NegRisk_Test is PredictDotLoan_Test {
    function test_acceptBorrowRequest_NegRisk_RevertIf_MarketResolved() public {
        IPredictDotLoan.Proposal memory proposal = _generateBorrowRequest(IPredictDotLoan.QuestionType.NegRisk);
        proposal.signature = _signProposal(proposal, borrowerPrivateKey);

        mockNegRiskAdapter.setDetermined(negRiskQuestionId, true);

        vm.prank(lender);
        vm.expectRevert(IPredictDotLoan.MarketResolved.selector);
        predictDotLoan.acceptBorrowRequest(proposal, proposal.loanAmount);
    }
}
