From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: about SDP on NE020 card
Date: Thu, 29 Apr 2010 10:55:17 +0200 (CEST)
Message-ID: <3076624.1272531317877.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <5464727.1272364442704.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BD6C9C3.6070905@mellanox.co.il> <2307255.1272463222662.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BD84318.7080506@mellanox.co.il> <3358583.1272465775631.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <4BD84C68.5000407@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BD84C68.5000407-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Apr 28, 2010 04:55 PM, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:

> comment it out in sdp_cma.c at:
> sdp_remove_device() and sdp_add_device()
> 
> If I am right, the problem that you see, is that ib_create_fmr_pool()
> is
> failing (you should see an error in dmesg), and because of that
> ib_set_client_data() is not called. And this is the reason for the
> error
> that you saw in the logs.
> 
> Because you won't be using ZCopy, no need to call ib_create_fmr_pool()
> -
> ofcourse, make sure you comment out the calls to ib_destroy_fmr_pool
> and
> ib_flush_fmr_pool()
> 
> - Amir

Hi Amir,

I put in off status the ZCopy with command:
# echo 0 > /sys/module/ib_sdp/parameters/sdp_zcopy_thresh 

I comment out some lines in file sdp_main.c, but now the programs don't
compile with a lot of errors.
I list out the lines that I have commented out:

file sdp_main.c
line 2625: struct ib_fmr_pool_param fmr_param
lines from 2645 to 2661
lines 2665 2666
lines from 2739 to 2745

All these lines contain a word "fmr".

I don't find word "fmr" in file sdp_cma.c; sdp_main.c calls objects of
sdp_cma.c

SDP doesn't work. The output message of dmesg command is:
sdp_init_qp:105 sdp_sock SDP not available on device nes0.

I would like identify the problem: if we are almost sure that Fast
Memory Region FMR is responsible for that, the bug 2028 solution in July
will remove the error and I hope that SDP will work fine. On the other
side, if FMR is not involved, there is an unknown situation and I am not
happy.

Could you evaluate the written error?
Could you give me your opinion?

Amir and Steve, thank you very much for help.

Regards,
Andrea


Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
