From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 17 Aug 2018 13:50:05 -0700
Message-ID: <CA+55aFyGLKSzS8O3m4JaE69wUm03tGOf+507jCCViTRQaGBGxw@mail.gmail.com>
References: <20180816215726.GA20526@ziepe.ca> <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
 <CA+55aFxD-Ua_jrrD1X6Y0Wd2gftP9=UVaa0uS=gi53zEEEAf3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxD-Ua_jrrD1X6Y0Wd2gftP9=UVaa0uS=gi53zEEEAf3w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2018 at 12:44 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, everything but the max_sge thing was trivial. I just took yours.

Oh, and doing the full test compile, I notice there  are new warnings.

That is *NOT* ok.

The whole "x is deprecated" is not a useful warning. If you can't
remove something, making it a reminder for yourself for later is not
an acceptable excuse for  bothering everybody else with the warning,
and possibly having other issues hidden because by the time there are
expected warnings, people will start ignoring the unexpected ones too.

So "__deprecated" is for stuff that really isn't used any more, to
catch possible new users. People have tried to use it for anything
else, but it's always  been a much bigger pain than it is worth.

I've considered just removing the whole deprecation infrastructure. It
has never really worked. Either its used, in which case deprecation
warnings only hide real issues, or it's not used, in which case the
function should just be removed.

               Linus
