From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
 received from network
Date: Wed, 30 Dec 2009 21:43:35 +0200
Message-ID: <20091230194335.GB26940@me>
References: <20091201194110.GA26753@comcast.net>
 <20091229150528.GV26940@me>
 <20091229150735.GX26940@me>
 <f0e08f230912300809l7c794daat9490c64a2cf63525@mail.gmail.com>
 <20091230162745.GZ26940@me>
 <f0e08f230912300856v188d5900u9d82c94f5f9ae4a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230912300856v188d5900u9d82c94f5f9ae4a6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:56 Wed 30 Dec     , Hal Rosenstock wrote:
> 
> Yes but why would SMA mess up attribute modifier though ?

How could I know? :)

> So is this
> just detecting OpenSM bug with AM ?

It is not for OpenSM internal bugs detecting. It is "don't trust to
information from a network", in this specific case attribute modifier
elements are used as pointers indexes (sl2vl tables), so OpenSM don't
need to crash due to broken SMAs or other sort of attack.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
