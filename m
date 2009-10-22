From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS
 rather than UMAD_CA_MAX_AGENTS
Date: Thu, 22 Oct 2009 15:35:43 +0200
Message-ID: <20091022133543.GJ20210@me>
References: <f0e08f230910220549g1035441dj3b89e543c44efd3a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910220549g1035441dj3b89e543c44efd3a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:49 Thu 22 Oct     , Hal Rosenstock wrote:
> >> =A0/****s* OpenSM: Vendor UMAD/osm_ca_info_t
> >> =A0* NAME
> >> =A0* =A0 osm_ca_info_t
> >> @@ -154,7 +156,7 @@ typedef struct _osm_vendor {
> >> =A0 =A0 =A0 osm_ca_info_t *p_ca_info;
> >> =A0 =A0 =A0 uint32_t timeout;
> >> =A0 =A0 =A0 int max_retries;
> >> - =A0 =A0 osm_bind_handle_t agents[UMAD_CA_MAX_AGENTS];
> >> + =A0 =A0 osm_bind_handle_t agents[OSM_UMAD_MAX_AGENTS];
> >
> > Any reason?
>=20
> To make the umad vendor layer "stand on its own". This was discussed
> in the Windows porting issues. See thread which ends
> http://lists.openfabrics.org/pipermail/ofw/2009-October/005819.html

I (and guess that many other OpenSM source and change log readers) am
not subscribed on ofw list and unaware about this discussion. Could you
summarize (in the patch change log) what is going on there and what is
motivation for this change?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
