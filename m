From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings in
 GCC 7.1
Date: Thu, 13 Jul 2017 17:54:12 +0000
Message-ID: <1499968451.2740.14.camel@wdc.com>
References: <20170713133935.1206-1-leon@kernel.org>
         <20170713175122.GD11069@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713175122.GD11069-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <23BEF50129E3584FBAD029C62B3A9B74-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 11:51 -0600, Jason Gunthorpe wrote:
> Can you follow the same approach as I used in
>=20
> commit 47cd2efcd4cd416ead0a1a48153aa27a2e178ce5
> Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date:   Tue Jan 31 14:55:50 2017 -0700
>=20
>     Annotate correct switch fall throughs with SWITCH_FALLTHROUGH
>=20
> Or convert those cases to this approach?
>=20
> >  			 * LE platform be32toh will do the job.
> >  			 */
> >  			hdr->key_immd =3D htole32(be32toh(wr->imm_data));
> > +			/* FALLTHROUGH */
>=20
> Use the SWITCH_FALLTHROUGH; macro

Hello Jason,

Both Coverity and gcc 7 understand fall-through comments. Do we really need
a macro to annotate fall-through in switch statements?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
