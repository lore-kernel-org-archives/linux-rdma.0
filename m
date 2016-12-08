From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: I/O error on dd commands
Date: Thu, 8 Dec 2016 11:25:38 +0200
Message-ID: <50499552-0842-a9f0-e46b-30b427b29ca9@mellanox.com>
References: <45c451dc71cc42b5bb24e385a160249a@TGXML382.toshiba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <45c451dc71cc42b5bb24e385a160249a-DqNMWkYM789gYsFYm0uEO7jjLBE8jN/0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/8/2016 2:45 AM, Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org wrote:
> Hi Max,
>
>> Any interesting logs in dmesg ?
>
> Dynamic debug was used and there was following log in dmesg of target.
>
> [  584.274459] rdma_rxe: qp#17 state = GET_REQ
> [  584.274461] rdma_rxe: qp#17 state = CHK_PSN
> [  584.274462] rdma_rxe: qp#17 state = CHK_OP_SEQ
> [  584.274464] rdma_rxe: qp#17 state = CHK_OP_VALID
> [  584.274465] rdma_rxe: qp#17 state = CHK_RESOURCE
> [  584.274467] rdma_rxe: qp#17 state = CHK_LENGTH
> [  584.274468] rdma_rxe: qp#17 state = CHK_RKEY
> [  584.274470] rdma_rxe: qp#17 state = EXECUTE
> [  584.274473] rdma_rxe: qp#17 state = COMPLETE
> [  584.274475] rdma_rxe: qp#17 state = ACKNOWLEDGE
> [  584.274496] rdma_rxe: qp#17 state = CLEANUP
> [  584.274498] rdma_rxe: qp#17 state = DONE
> [  584.274499] rdma_rxe: qp#17 state = GET_REQ
> [  584.274500] rdma_rxe: qp#17 state = EXIT
> [  584.275561] nvmet_rdma: IB send queue full (needed 1): queue 0 cntlid 1
>
> thanks,
> Haruo.
>

Very wierd. can you pring "queue->host_qid" also in nvmet_rdma  
nvmet_rdma_execute_command (IB send queue full (needed 1): queue_idx 0  
cntlid 1 queue_qid ????).

seems like it's the admin queue but i'm not sure.

Moni,
can you advise regarding rdma_rxe logs ?

thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
