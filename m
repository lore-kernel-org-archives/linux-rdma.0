From: Varsha Rao <rvarsha016@gmail.com>
Subject: Re: [PATCH] drivers: infiniband: core: Remove extra parentheses
Date: Thu, 26 Jul 2018 14:02:46 +0200
Message-ID: <CAAFX7JQSpKKPhiV7GL0wCecabgTudE0yN5m+gT1e6MqsJUt2uw@mail.gmail.com>
References: <20180725184356.3754-1-rvarsha016@gmail.com> <20180725203733.GA5678@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="000000000000aa2d880571e5c63e"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725203733.GA5678@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, Nicholas Mc Guire <der.herr@hofr.at>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

--000000000000aa2d880571e5c63e
Content-Type: text/plain; charset="UTF-8"

Hi Jason,

On Wed, Jul 25, 2018 at 10:37 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Jul 25, 2018 at 08:43:56PM +0200, Varsha Rao wrote:
> > Remove unnecessary parentheses to fix the clang warning of extraneous
> > parentheses.
> >
> > Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> > ---
> >  drivers/infiniband/core/cma.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Applied to for-next, thanks
>
> Curious, what configuration are you using clang with? I'd like to have
> it run here..
>
> I have the list of warnings from previous kernel build, for which
compiling with clang was possible. I sent the patch as the warning was
still valid for the latest kernel too.

Thanks,
Varsha

--000000000000aa2d880571e5c63e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div dir=3D"ltr">Hi Jason,<br><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Wed, Jul 25, 2018 at 10:37 PM, Jason Gunt=
horpe <span dir=3D"ltr">&lt;<a href=3D"mailto:jgg@ziepe.ca" target=3D"_blan=
k" rel=3D"noreferrer">jgg@ziepe.ca</a>&gt;</span> wrote:<br><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex"><span>On Wed, Jul 25, 2018 at 08:43:56PM +0200, Varsha Rao =
wrote:<br>
&gt; Remove unnecessary parentheses to fix the clang warning of extraneous<=
br>
&gt; parentheses.<br>
&gt; <br>
&gt; Signed-off-by: Varsha Rao &lt;<a href=3D"mailto:rvarsha016@gmail.com" =
target=3D"_blank" rel=3D"noreferrer">rvarsha016@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/infiniband/core/cma.c | 2 +-<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
</span>Applied to for-next, thanks<br>
<br>
Curious, what configuration are you using clang with? I&#39;d like to have<=
br>
it run here..<br>
<span class=3D"m_2450782651544013136HOEnZb"><font color=3D"#888888"><br></f=
ont></span></blockquote><div>I have the list of warnings from previous kern=
el build, for which compiling with clang was possible. I sent the patch as =
the warning was still valid for the latest kernel too.</div><div dir=3D"aut=
o"><br></div><div dir=3D"auto">Thanks,</div><div dir=3D"auto">Varsha</div><=
div><br></div></div><br></div></div></div>

--000000000000aa2d880571e5c63e--
