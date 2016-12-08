From: <Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org>
Subject: RE: I/O error on dd commands
Date: Thu, 8 Dec 2016 00:45:17 +0000
Message-ID: <45c451dc71cc42b5bb24e385a160249a@TGXML382.toshiba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: ja-JP
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Max,

> Any interesting logs in dmesg ?

Dynamic debug was used and there was following log in dmesg of target.

[  584.274459] rdma_rxe: qp#17 state = GET_REQ
[  584.274461] rdma_rxe: qp#17 state = CHK_PSN
[  584.274462] rdma_rxe: qp#17 state = CHK_OP_SEQ
[  584.274464] rdma_rxe: qp#17 state = CHK_OP_VALID
[  584.274465] rdma_rxe: qp#17 state = CHK_RESOURCE
[  584.274467] rdma_rxe: qp#17 state = CHK_LENGTH
[  584.274468] rdma_rxe: qp#17 state = CHK_RKEY
[  584.274470] rdma_rxe: qp#17 state = EXECUTE
[  584.274473] rdma_rxe: qp#17 state = COMPLETE
[  584.274475] rdma_rxe: qp#17 state = ACKNOWLEDGE
[  584.274496] rdma_rxe: qp#17 state = CLEANUP
[  584.274498] rdma_rxe: qp#17 state = DONE
[  584.274499] rdma_rxe: qp#17 state = GET_REQ
[  584.274500] rdma_rxe: qp#17 state = EXIT
[  584.275561] nvmet_rdma: IB send queue full (needed 1): queue 0 cntlid 1

thanks,
Haruo.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
