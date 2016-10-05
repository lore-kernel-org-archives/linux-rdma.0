From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: RDMA developer gatherings around Kernel Summit and Linux Plumbers
 in Santa Fe
Date: Wed, 5 Oct 2016 13:02:38 +0000
Message-ID: <BED3F60E-08E7-4C29-8A52-E7F879BE46A4@ornl.gov>
References: <alpine.DEB.2.20.1610040344500.11122@east.gentwo.org>
 <20161004124513.GA12483@infradead.org>
 <7BAAE610-98A0-47FC-993B-77401AA32F4A@ornl.gov>
 <alpine.DEB.2.20.1610050242260.27600@east.gentwo.org>
 <20161005083218.GA16922@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161005083218.GA16922-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Content-ID: <793F644F7AA42A43BA2C1D089FD7F60F-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, "shewa-YOWKrPYUwWM@public.gmane.org" <shewa-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Oct 5, 2016, at 4:32 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>=20
> Could someone elaborate what the OFA position is?  Right now the only
> thing I know is that they are a) forcing their members to Dual license
> code nd have b) some sort of weird idea that they could also force this
> on others in some way.

Although I am sitting on the OFA board as the representative of my organiza=
tion, I do not speak for the OFA. These are my observations:

1. The OFA is an organization to promote the standardization of alternative=
 network technologies. Prior to the OFA, vendors created specialized hardwa=
re with specialized software stacks tailored to HPC. Examples include QSnet=
/Quadrics, GM/Myrinet MX/Myrinet, Cray Portals/SeaStar, Cray GNI/Gemini/Ari=
es, IBM BG[LPQ], etc. The OFA evolved from the InfiniBand/Verbs trade group=
 in order to promote additional technologies (e.g. iWarp, RoCE, PSM, etc).

2. The OFA organization, made up of various members, has rules to govern it=
self. Most members are also competitors. They cooperate on standards becaus=
e everyone benefits by avoiding the fragmentation of the prior state of aff=
airs (see item 1). Because they are competitors, changes are difficult and/=
or slow because people have to build consensus. Other members are consumers=
, for example the organization I represent, and we want standards and compe=
tition. The former allows us to get better products from the latter.

3. The members that contribute the most to the OFA in terms of money, staff=
 time, and code are the vendors. They wrote much of the code that was contr=
ibuted and they chose dual license, as is their right. I assume (because I =
do not know) that they did so to avoid writing two (or three) stacks for Li=
nux and non-Linux environments.

4. OFA has a rule that code developed on its behalf be dual-license. They d=
o not _force_ this on members because members decided this or they joined k=
nowing that this was the rule. OFA cannot force anyone to join so therefore=
 they cannot force anyone to adopt a dual-license. As mentioned in item 2, =
OFA members can modify their rules via an established process. If you want =
to change the rule, join OFA and convince the members.

5. The only one in this thread trying to force a license of others is not t=
he OFA.

> I personally think that a) is not helpful to the adoption of RDMA
> technologies in Linux, and that b) is obviously a complete non-started
> as confirmed multiple times, which isn't just my own opinion.

If one is not a member, the OFA cannot force anything. I do not see dual-li=
cense as a hindrance to Linux kernel use or adoption. Perhaps you can help =
me understand better.

> Based on that I really don't understand what the point of this
> discussion is, unless OFA really needs help with an internal discussion
> to get rid of a).  If Christoph really wants me to help with a) please
> do it during Plumbers as I won't be around on Saturday.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
