From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: are IB port counters functioning over --IB-- with the RDMAoE
 	patch set?
Date: Mon, 07 Jun 2010 17:28:04 +0300
Message-ID: <4C0D01F4.6090804@voltaire.com>
References: <4BFE35B7.80009@voltaire.com> <4C0796C1.1040106@voltaire.com>	<7E95F01E94AB484F83061FCFA35B39F854FBAA@exil.voltaire.com>	<4C07AF24.6000006@voltaire.com>	<AANLkTin5E1BHRr4pwWnueo0zqhn_3VyQThRVSFTiAZad@mail.gmail.com>	<4C0CF44C.5030702@Voltaire.com> <AANLkTinT9KSwT16drtXPC2kfr6fF4NJJMBhF6ga3jpMp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinT9KSwT16drtXPC2kfr6fF4NJJMBhF6ga3jpMp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> Why are you asking me to validate that? Did you actually encounter a problem with this?
yes, I did. It didn't work with some ofed drop I was using. Anyway, as I 
said, I can do some validation that IBoE doesn't break upstream IB, just 
need the patches for that end, so once they are available, I will give 
them a try over 2.6.35-rcX

> The counters patches will divert the code: for iboe it will not issue a MAD to the firmware. It will use another command.
Can you be more specific what is the origin for this new design? is it 
HW limitation or firware limitation or something else? In case its not 
hardware limitation, I don't think we need to go for non MAD based 
scheme, at least not for mlx4

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
