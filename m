From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: RFC: Splitting of the management git tree in Open Fabrics
Date: Thu, 2 Sep 2010 14:05:39 -0700
Message-ID: <20100902140539.edebfccb.weiny2@llnl.gov>
References: <20100831125159.98e6d201.weiny2@llnl.gov>
	<AANLkTimyyKEnFe3yuRBPzMp5Vx21PMyq=yJQMWyph3cu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <AANLkTimyyKEnFe3yuRBPzMp5Vx21PMyq=yJQMWyph3cu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2 Sep 2010 13:36:34 -0700
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Ira,
> =

> On Tue, Aug 31, 2010 at 3:51 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > As I briefly mentioned in an email to Yevgeny regarding libibumad ABI's=
; I
> > believe it is time to break up the management git tree.
> =

> I think these are separate issues. What are you trying to achieve by
> doing this ?

Yes they are separate issues.  That is why I started this thread.

When I said "I think it is time to break up the management git tree" I was
thinking along the lines that umad and mad are libraries used by tools outs=
ide
of OpenSM and infiniband-diags.  As such I think it would be easier to
maintain them as separate trees.  This includes maintaining branches and
versions with consistent ABI's.

Ira

> =

> -- Hal
> =

> > With GA of OFED 1.5.2 scheduled for Sept 13, I would like to request co=
mments
> > from the community about the following split after that GA.
> >
> > On openfabrics.org/git split management.git into the following trees.
> >
> > openfabrics.org/git/infiniband-diags.git
> > openfabrics.org/git/libibumad.git
> > openfabrics.org/git/libibmad.git
> > openfabrics.org/git/opensm.git
> >
> > Sasha can populate those from the current management tree. =A0We believ=
e there
> > are git commands which will do this without losing any history from the=
 git
> > trees.
> >
> > Vlad, what changes would you have to make in the OFED build to accommod=
ate
> > these packages being in separate git trees?
> >
> > Any other concerns or comments?
> >
> > Thanks,
> > Ira
> >
> > --
> > Ira Weiny
> > Math Programmer/Computer Scientist
> > Lawrence Livermore National Lab
> > 925-423-8008
> > weiny2-i2BcT+NCU+M@public.gmane.org
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://*vger.kernel.org/majordomo-info.html
> >
> =



-- =

Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
