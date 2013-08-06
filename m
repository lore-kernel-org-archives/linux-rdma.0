From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 0/4] Add receive Flow Steering support
Date: Tue, 6 Aug 2013 16:11:41 +0300
Message-ID: <5200F60D.8060500@mellanox.com>
References: <1372873336-13694-1-git-send-email-ogerlitz@mellanox.com> <20130805205437.GA7488@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130805205437.GA7488-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/08/2013 23:54, Shawn Bohrer wrote:
> The problem with running and testing this code is that many of these
> features are posted in incomplete (from the user point of view)
> chunks.  As an example I don't really see how anyone is currently
> using raw QPs on upstream code since this flow steering patch set is
> missing, I still haven't seen the corresponding patches to libibverbs,
> and IP checksum support is still missing from the send side.

Hi Shawn,

Its common for features to be submitted in bottom/up manner, that is 1st
the kernel part with the API to user space and only later the user space 
implementation.

Still, your input and testing is very much valuable, I will send you 
user space
patches for libmlx4 and libibverbs so you can test the kernel patches.


Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
