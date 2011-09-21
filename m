From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] [libibmad] Support new ibccquery congestion
 control tool
Date: Wed, 21 Sep 2011 08:49:34 -0700
Message-ID: <20110921084934.b300e682.weiny2@llnl.gov>
References: <1316469989.25283.728.camel@auk59.llnl.gov>
	<CAKzyTsxKD0r9194fd1haQ0u=1kXLDhrRXLL8q+=+inV5BM1mog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKzyTsxKD0r9194fd1haQ0u=1kXLDhrRXLL8q+=+inV5BM1mog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Sep 2011 07:17:38 -0700
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi Al,
>=20
> On Mon, Sep 19, 2011 at 6:06 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> > The following patches add a new tool ibccquery to infiniband-diags.=
 =A0It
> > supports the querying of various congestion control settings. =A0Re=
lated
> > updates to libibmad are also included.
>=20
> Looks good to me :-) Just a few comments below:
>=20
> Attaching rather than inlining patches makes it harder to comment.
>=20
> On 0001-Add-support-for-congestion-control-mads.patch, is ib_rpc_cc_t
> really needed ? Couldn't mkey in existing rpc struct just be
> reused/overloaded for this (and change comment to indicate mkey or
> cckey) and then some code could be eliminated ?

I am not sure I like overloading fields like this.  I will take a look =
at it
and see if it "looks" good but in general to keep ABI and clarity of th=
e code
I preferred the separate struct.

>=20
> On 0001-Support-ibccquery-congestion-control-query-tool.patch, I'm
> worried about the following:
> +		/* XXX: Q3/2010 errata lists first entry offset at 80, but we assu=
me
> +		 * will be updated to 96 once CurrentTimeStamp field is word align=
ed.
> +		 * In addition, assume max 13 log events instead of 16.  Due to
> +		 * errata changes increasing size of CA log event, 16 log events i=
s
> +		 * no longer possible to fit in max MAD size.
> +		 */
>=20
> As far as the 13 v. 16 entries, this appears correct to me (MAD size)
> but I'm concerned about changing the offset from 80 to 96 for better
> alignment as this is putting the cart before the horse a little as
> since these changes have not been finalized AFAIK at the IBTA.

Yes, it is a bit premature.  I have submitted the above alignment as a =
comment
to the IBTA but as you say it is not published.  Most importantly the
miss-alignment breaks the convention of the spec.  So I don't think the=
 IBTA
will reject the comment.

Second the current alignment breaks libibmad.  So it would be a lot mor=
e code
to support the miss-alignment and would probably have to be changed any=
way.

>=20
> Also, would you comment on what testing has been done with this ?
>=20

Right, the real question is what does current hardware do?

We have been unable to determine if any of the vendors support the erra=
ta
fully or specifically the miss-aligned CurrentTimeStamp.  When I asked =
the
vendors I got concrete answers back, so we proceeded with trying to rev=
erse
engineer it.  Right now the query succeeds, that is all we know.

Perhaps someone on the list can help us find out?  :-D

In the meantime we wanted to get comments on the patches.

Ira

> -- Hal
>=20
> > Al
> >
> > --
> > Albert Chu
> > chu11-i2BcT+NCU+M@public.gmane.org
> > Computer Scientist
> > High Performance Systems Division
> > Lawrence Livermore National Laboratory
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
