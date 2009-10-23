From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad.c: Add environment variable
 to change max retries
Date: Sat, 24 Oct 2009 00:41:03 +0200
Message-ID: <20091023224103.GJ5764@me>
References: <20091019183342.GA28926@comcast.net>
 <20091022122443.GF20210@me>
 <f0e08f230910220556h3d7352f4s4bd8e57c0a01a5d0@mail.gmail.com>
 <20091022135004.GK20210@me>
 <f0e08f230910220841s220373fau2cd4e814ec77ca25@mail.gmail.com>
 <20091023213308.GE5764@me>
 <f0e08f230910231502p1758a8ag6c3852802aca40a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910231502p1758a8ag6c3852802aca40a7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 18:02 Fri 23 Oct     , Hal Rosenstock wrote:
> 
> Somehow passing retries in to the vendor layer (either as an
> additional API or parameter to existing API) would change the API and
> I see no way to get to the subnet options where retries is held from
> the vendor layer.

You can pass it (as well as timeout) as part of bind_info struct, and
even make it per umad agent.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
