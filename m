From: Andy Walls <awalls@md.metrocast.net>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 15 Apr 2015 20:33:18 -0400
Message-ID: <1429144398.1899.73.camel@palomino.walls.org>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
	 <1429138212.1899.34.camel@palomino.walls.org>
	 <CALCETrU9FEoXgWxV+XXwRdKTxUxYj7CD3ropnFb4Pq1cMkucaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU9FEoXgWxV+XXwRdKTxUxYj7CD3ropnFb4Pq1cMkucaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, linux-rdma@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Thomas Gleixner <tglx@linutronix.de>, Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <sy>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2015-04-15 at 16:52 -0700, Andy Lutomirski wrote:
> On Wed, Apr 15, 2015 at 3:50 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Wed, 2015-04-15 at 13:42 -0700, Andy Lutomirski wrote:
> >> On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >>
> >> > c) ivtv: the driver does not have the PCI space mapped out separately, and
> >> > in fact it actually does not do the math for the framebuffer, instead it lets
> >> > the device's own CPU do that and assume where its at, see
> >> > ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> >> > but not a setter. Its not clear if the firmware would make a split easy.
> >> > We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
> >> >
> >>
> >> IMO this should be conceptually easy to split.  Once we get the
> >> framebuffer address, just unmap it (or don't prematurely map it) and
> >> then ioremap the thing.
> >
> > Not so easy.  The main ivtv driver has already set up the PCI device and
> > done the mapping for the MPEG-2 decoder/video output engine.  The video
> > decoder/output device nodes might already be open by user space calling
> > into the main driver, before the ivtvfb module is even loaded.
> 
> Surely the MPEG-2 decoder/video engine won't overlap the framebuffer,
> though.  Am I missing something?

ivtvfb is stealing the decoders' OSD for use as a framebuffer.
The decoder video output memory doesn't overlap the decoder OSD memory,
but there is a functional overlap.  ivtv driver video output device
nodes can manipulate the OSD that ivtvfb is stealing.

It would be a dumb thing for the user to want to use ivtvfb, and to also
manipulate the OSD via the video output device nodes at the same time,
for anything other than setting up the TV video standard.  However the
current ivtv driver code doesn't prevent the OSD from being manipulated
by the video output device nodes when ivtvfb is in use.

-Andy
