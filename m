From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for multicast handling
Date: Wed, 21 Jan 2015 12:34:33 -0500 (EST)
Message-ID: <CA0F10E4-72EA-4143-87B0-33C9566F265E@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com> <54BE7F66.4070404@dev.mellanox.co.il> <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It's worse than 3.18, but only if your test is rmmod ipoib based. For normal running conditions it's better. However, I'm going to try and fix the rmmod issue today if at all possible.

Sent from my iPhone

> On Jan 21, 2015, at 12:20 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
>> On Tue, Jan 20, 2015 at 8:16 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> 
>> After trying your V4 patch series, I can tell that first, the endless scheduling of
>> the mcast task is indeed over, but still, the multicast functionality in ipoib is unstable.
> 
> Is this worse than 3.18?  (Have you tested that?)
> 
> Because Doug's changes fixed some bad, easy-to-reproduce issues.  On
> the other hand we don't want to introduce new regressions to fix the
> old issues.
> 
> I think we only have a few days to decide whether to revert back to
> 3.18 code, or push forward with these fixes.
> 
> - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
