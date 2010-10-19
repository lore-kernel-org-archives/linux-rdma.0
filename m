From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib mad definitions
Date: Tue, 19 Oct 2010 10:22:44 -0700
Message-ID: <20101019102244.21cd2b1e.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
	<AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Oct 2010 08:43:22 -0700
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Oct 19, 2010 at 11:28 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> =
wrote:
> >> > but is there a strong reason why ib_types.h can't be moved from
> >> opensm/include/iba to libibumad/include/infiniband?
> >>
> >> Why does this need to be moved ?
> >
> > The dependency should be on libibumad, not opensm. =A0libibumad is =
pretty much useless without these definitions. =A0Why wouldn't you move=
 them?
>=20
> Off the top of my head, OpenSM is layered on top of libibumad but
> doesn't need/use libibmad. I think that was the main reason although
> that could be changed if ib_types.h were to be moved. I'm not sure
> what other reasons came up in the previous discussions.

I think ib_types.h should be part of ibumad.  Everything depends on lib=
ibumad
at some point.[*]  Therefore common mad definitions should be in ib_typ=
es.h and
packaged with libibumad.

[*] ok OpenSM does not strictly, see below.

>=20
> >
> >> There already are diags including ib_types.h (saquery for one).
> >
> > Yes, but we're either stuck with everything that needs ib_types.h t=
o be part of the management.git tree, or the app needs to depend on ope=
nsm. =A0Currently, ibacm duplicates definitions because they aren't ava=
ilable anywhere else.
>=20
> I agree ib_types.h is more generic than opensm. Moving to libibmad an=
d
> making opensm depend on this is probably better than all the
> duplication. There have been viewpoints that libibumad and libibmad
> shouldn't be separate (as they are small) but they were never combine=
d
> into a single library.

The opposing view is that libibumad is only an interface to the kernel =
umad
module, where libibmad is more abstract.


As far as moving ib_types, I suggested this a while back.
http://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg27439.html

Let's see if I can summarize the thread.

- Sean was workiong on libibacm and redefined ib_types.h definitions.
- I suggested moving ib_types.h to umad so he would not have a dependan=
cy on
  OpenSM.
- Sean brought up that ib_types.h is large and probably should be split
- I agreed, and asked Sasha if such a patch would be acceptable, or cre=
ate a
  new library to deal with the inline functions in ib_types.h
- Hal said that ibutils requires ib_types.h but does not want a dependa=
ncy on
  libibumad...
- I suggested a separate library to solve this problem.
- Hal corrected himself saying that ibutils requires osm_vendor_ibumad.
  However, OpenSM does not always use libibumad (depending on the under=
lying
  stack) so it would need to get ib_types somewhere else.  Hal was also
  concerned about a library with little more than a header file in it.
- Jason chimed in with "Please no more libraries"...  :-)  (and digress=
ed with
  Sean in to PR queries, MPI, and other useful, but unrelated, stuff)
- Sean says "libibumad is pretty useless without some network structure
  definitions."
- I state that it looks like ibutils dependancy is on the static functi=
ons in
  ib_types.h only.
- Hal says yes ibutils depends on OpenSM for the vendor layer and that
  Mellanox is better able to answer questions regarding ibutils support=
=2E
- Hal says he thinks ib_types is "more akin to what is in libibmad rath=
er than
  libibumad"
- Sean finds that ib_types.h includes complib headers.
- I submit a "rough hack" to remove complib headers.
- Jason, Sean, and myself discuss ugly byteswapping functions.
- Sasha agrees that he is not sure that umad is the right place for ib_=
types
- Sean says we should split the file up and at least some of the defini=
tions
  should be in umad...


We all get busy...


I think we need to move ib_types (mad definitions to umad).

Basic MAD definitions should be provided at the lowest possible level s=
o all
software can use them.

The issues (solutions) are:

ib_types depends on complib at the moment (fixable)
ibutils depends on OpenSM (it will anyway -- non-issue)
somethings in ib_types are ugly, byteswapping (non-issue; deal with it =
later)
OpenSM may _not_ include umad and therefore miss defines. (fixable?)

As for this last item, would it be a big deal to require umad for the h=
eader
only?  Does umad not compile somewhere that other vendor layers are use=
d?  I
think it is much better for OpenSM to require umad than for other MAD
processing software to require OpenSM.  Also, would splitting ib_types =
help
this at all?


Ira

>=20
> -- Hal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://BLOCKEDvger.kernel.org/majordomo-info.=
html
>=20


--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
