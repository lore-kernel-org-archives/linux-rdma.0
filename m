From: <Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org>
Subject: RE: I/O error on dd commands
Date: Fri, 16 Dec 2016 04:25:14 +0000
Message-ID: <27f025d42ed4492d8bddf25c2d48ed95@TGXML382.toshiba.local>
References: <45c451dc71cc42b5bb24e385a160249a@TGXML382.toshiba.local>
 <50499552-0842-a9f0-e46b-30b427b29ca9@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50499552-0842-a9f0-e46b-30b427b29ca9-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: ja-JP
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Max and Moni,

"IB send queue full" issue is reproduced easily in vanilla kernel4.9.

> Very wierd. can you pring "queue->host_qid" also in nvmet_rdma  
> nvmet_rdma_execute_command (IB send queue full (needed 1): queue_idx 0  
> cntlid 1 queue_qid ????).
> 
> seems like it's the admin queue but i'm not sure.
> 
> Moni,
> can you advise regarding rdma_rxe logs ?

" queue->host_qid" is printed. When there is other information to debug
for this issue, please tell me.

thanks,
Haruo.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
