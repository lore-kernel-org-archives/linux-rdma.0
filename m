From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: are IB port counters functioning over --IB-- with the RDMAoE
	patch set?
Date: Mon, 7 Jun 2010 12:40:45 +0300
Message-ID: <AANLkTin5E1BHRr4pwWnueo0zqhn_3VyQThRVSFTiAZad@mail.gmail.com>
References: <4BFE35B7.80009@voltaire.com>
	<4C0796C1.1040106@voltaire.com>
	<7E95F01E94AB484F83061FCFA35B39F854FBAA@exil.voltaire.com>
	<4C07AF24.6000006@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C07AF24.6000006-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or, counter should work as regular in upstream kernel patches for IB
link layer. For IBoE, they will not work since the SMA does not
support them. I have patches that allow to show counters using sysfs
but those have not yet been sent upstream. They available in
OFED-1.5.2 latest builds.

On Thu, Jun 3, 2010 at 4:33 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Moni Shoua wrote:
>>
>> Did you try OFED-1.5.1 or even better, OFED-1.5.2? I know patches for
>> counters with RoCEE were submitted since OFED-1.5 and I saw it working
>
> Mony, I'm not using ofed, sorry... I am interested in a clarification in the
> context of the upstream submission, e.g does the problem exist in the latest
> patch-set, is there a bz case tracking this, etc.
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
