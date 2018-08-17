From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 17 Aug 2018 16:56:46 -0700
Message-ID: <CA+55aFyhXDgSVMEhXcEzTSX4oCJEYwKM1vFbjnsOah7F0siGFw@mail.gmail.com>
References: <20180816215726.GA20526@ziepe.ca> <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
 <CA+55aFxD-Ua_jrrD1X6Y0Wd2gftP9=UVaa0uS=gi53zEEEAf3w@mail.gmail.com>
 <CA+55aFyGLKSzS8O3m4JaE69wUm03tGOf+507jCCViTRQaGBGxw@mail.gmail.com> <20180817211648.GK28676@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180817211648.GK28676@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2018 at 2:17 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> Would you like a patch to remove that CONFIG option?

I've definitely considered it and would almost certainly just apply a
patch that removed it.

We haven't had this issue for a while (because people stopped using
the deprecated thing), so it ended up not having been an issue lately.
Yours was the first case of deprecation warnings I've seen in a
longish while.

          Linus
