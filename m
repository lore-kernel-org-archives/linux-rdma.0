From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] [PATCH 2/2 v4] opensm: Compression of multicast
	group according to pkey
Date: Wed, 30 Sep 2009 09:40:28 -0400
Message-ID: <f0e08f230909300640r69936ee5w2ff59d5cfa2a7cd6@mail.gmail.com>
References: <4AC21184.4010103@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AC21184.4010103-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 29, 2009 at 9:54 AM, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Additional data structure added:
> 1. Map of all partition keys opened in the fabric.
> 2. Map of all multicast group boxes shared same pkey.
> MLID assignment for multicast groups works in a usual manner,
> allocating free entry for newly created group.
> Proposed compression algorithm starts working when there are no more
> free entries in the mlid array. List of MLIDs for new multicast group
> will be chosen from the pkey indexed map according to the requested
> pkey. MLID which shares minimum number of ports will be given to newly
> created multicast group.

Other suitability criteria aside from minimum number of ports (which
is debatable), are MTU and rate matching. Are MTU and rate also
checked (in addition to pkey) ? If not, IMO these checks should be
added.

-- Hal

> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
