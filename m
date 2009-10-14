From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Reduce heap consumption by multicast routing
 tables (MFTs)
Date: Wed, 14 Oct 2009 21:54:43 +0200
Message-ID: <20091014195443.GF13830@me>
References: <20091014155224.GA21566@comcast.net>
 <20091014162526.GE13830@me>
 <f0e08f230910141246r273555f6teed717711511b0d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910141246r273555f6teed717711511b0d5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:46 Wed 14 Oct     , Hal Rosenstock wrote:
> 
> Seems to me that the equivalent (to LFT) is to invoke the table
> (re)allocation from osm_mcast_mgr_process/process_mgroups. Is that
> what you mean ?

Yes, exactly.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
