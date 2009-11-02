From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/mcast_tbl: set max_mlid_ho as actually
 configured mlid
Date: Mon, 2 Nov 2009 18:43:43 +0200
Message-ID: <20091102164343.GJ21323@me>
References: <4AEAEA86.8080309@systemfabricworks.com>
 <f0e08f230910300648m4d802f57w2910cea678a3cd1f@mail.gmail.com>
 <20091030200620.GB5829@me>
 <f0e08f230910301344j5b9564a5k9b77fd4e43e48376@mail.gmail.com>
 <20091030213125.GE5829@me>
 <f0e08f230911020818n2f2f4dcai5c920dbfa98551de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230911020818n2f2f4dcai5c920dbfa98551de-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12:18 Mon 02 Nov     , Hal Rosenstock wrote:
> >
> > Yet another (likely even more efficient) approach would be memset()ing
> > MFTs in realloc function above requested mlid_offset, then we will be
> > able to remove osm_mcast_tbl_clear_mlid() completely.
> 
> Isn't mlid clearing done on a per mlid basis rather than based on
> above some mlid (offset) ? Also and perhaps more significantly, an
> mlid can be removed in the middle of a range of mlids. So I don't see
> how clear_mlid can be removed.

Yes, correct, we cannot remove clear_mlid completely.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
