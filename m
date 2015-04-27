From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH] IB/ipath: use arch_phys_wc_add() and require PAT disabled
Date: Mon, 27 Apr 2015 09:46:21 -0700
Message-ID: <CAB=NE6UHnEuMHfFaXBNr4F=RcDcEC3z6rX8-B_10Sbpr7kHkiA@mail.gmail.com>
References: <1429730795-6721-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429730795-6721-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <infinipath@intel.com>, roland@kernel.org, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, "Michael S. Tsirkin" <mst@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Bo
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 12:26 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> We are burrying direct access to MTRR code support on
> x86 in order to take advantage of PAT. In the future we
> also want to make the default behaviour of ioremap_nocache()
> to use strong UC, use of mtrr_add() on those systems
> would make write-combining void.
>
> In order to help both enable us to later make strong
> UC default and in order to phase out direct MTRR access
> code port the driver over to arch_phys_wc_add() and
> annotate that the device driver requires systems to
> boot with PAT disabled, with the nopat kernel parameter.
>
> This is a worthy compromise given that the ipath device
> driver powers the old HTX bus cards that only work in
> AMD systems, while the newer IB/qib device driver
> powers all PCI-e cards. The ipath device driver is
> obsolete, hardware hard to find and because of this
> this its a reasonable compromise to make to require
> users of ipath to boot with nopat.

Hey folks, I realize its being discussed whether or not to remove the
driver entirely from the kernel but in the meantime, is this a
reasonable compromise ?

 Luis
