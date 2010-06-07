From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: are IB port counters functioning over --IB-- with the RDMAoE
 	patch set?
Date: Mon, 07 Jun 2010 16:29:48 +0300
Message-ID: <4C0CF44C.5030702@Voltaire.com>
References: <4BFE35B7.80009@voltaire.com> <4C0796C1.1040106@voltaire.com>	<7E95F01E94AB484F83061FCFA35B39F854FBAA@exil.voltaire.com>	<4C07AF24.6000006@voltaire.com> <AANLkTin5E1BHRr4pwWnueo0zqhn_3VyQThRVSFTiAZad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin5E1BHRr4pwWnueo0zqhn_3VyQThRVSFTiAZad-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> counter should work as regular in upstream kernel patches for IB link layer. 

okay good, can you validate that? basically, I can set some time to clone Roland's tree
and use the iboe branch as a basis for testing that the IB stack is live and kicking as it used to be before the patches. I just need an updated copy of the rest of the patch set (Roland has three patches so far) for that end. Over the review process there were bunch of comments but no new posting, how are you planning to proceed in the review/merge process?

> for IBoE, they will not work since the SMA does not support them
> I have patches that allow to show counters using sysfs 

I am not with you. The counters are read using a MAD sent to the firmware PMA (QP #1), 
this applies for both perfquery and sysfs, isn't it? 

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
