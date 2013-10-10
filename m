From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 0/4] Add receive Flow Steering support
Date: Thu, 10 Oct 2013 21:53:49 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C01442230@xmb-rcd-x09.cisco.com>
References: <1372873336-13694-1-git-send-email-ogerlitz@mellanox.com>
 <20130805205437.GA7488@sbohrermbp13-local.rgmadvisors.com>
 <5200F60D.8060500@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5200F60D.8060500-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <27724E1593A141459F25A8862A79B9A6-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,
	Can u *please* post the corresponding libibverbs patches, when they become ready, on the mailer please.  We would also like to try them out.  If they are not ready, can u give us a ballpark ETA?

Upinder

On Aug 6, 2013, at 6:11 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> On 05/08/2013 23:54, Shawn Bohrer wrote:
>> The problem with running and testing this code is that many of these
>> features are posted in incomplete (from the user point of view)
>> chunks.  As an example I don't really see how anyone is currently
>> using raw QPs on upstream code since this flow steering patch set is
>> missing, I still haven't seen the corresponding patches to libibverbs,
>> and IP checksum support is still missing from the send side.
> 
> Hi Shawn,
> 
> Its common for features to be submitted in bottom/up manner, that is 1st
> the kernel part with the API to user space and only later the user space implementation.
> 
> Still, your input and testing is very much valuable, I will send you user space
> patches for libmlx4 and libibverbs so you can test the kernel patches.
> 
> 
> Or.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
