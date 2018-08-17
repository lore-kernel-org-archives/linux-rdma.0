From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 17 Aug 2018 15:16:48 -0600
Message-ID: <20180817211648.GK28676@mellanox.com>
References: <20180816215726.GA20526@ziepe.ca>
 <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
 <CA+55aFxD-Ua_jrrD1X6Y0Wd2gftP9=UVaa0uS=gi53zEEEAf3w@mail.gmail.com>
 <CA+55aFyGLKSzS8O3m4JaE69wUm03tGOf+507jCCViTRQaGBGxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyGLKSzS8O3m4JaE69wUm03tGOf+507jCCViTRQaGBGxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2018 at 01:50:05PM -0700, Linus Torvalds wrote:
> On Fri, Aug 17, 2018 at 12:44 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ok, everything but the max_sge thing was trivial. I just took yours.
> 
> Oh, and doing the full test compile, I notice there  are new warnings.
>
> That is *NOT* ok.

I expect to send you a pull request to remove all of this next
week. This is fall out from the SMC merge conflict reversion.

> The whole "x is deprecated" is not a useful warning. If you can't
> remove something, making it a reminder for yourself for later is not
> an acceptable excuse for  bothering everybody else with the warning,
> and possibly having other issues hidden because by the time there are
> expected warnings, people will start ignoring the unexpected ones too.
> 
> So "__deprecated" is for stuff that really isn't used any more, to
> catch possible new users. People have tried to use it for anything
> else, but it's always  been a much bigger pain than it is worth.

In this case it has become confusing what
CONFIG_ENABLE_WARN_DEPRECATED is for.

If the kernel is supposed to compile warning free with that config
set, then why have the config at all - it does nothing, by definition?

Would you like a patch to remove that CONFIG option?

Jason
