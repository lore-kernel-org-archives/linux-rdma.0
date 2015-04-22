From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 12:14:04 -0700
Message-ID: <CAB=NE6U91sMEXDdpu0BeL066j2EPho=owM-H=_8-4yCkWBVKbA@mail.gmail.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de> <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de> <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de> <20150422161755.GA19500@obsidianresearch.com>
 <1429728791.121496.10.camel@redhat.com> <20150422190520.GL5622@wotan.suse.de> <1429729841.121496.15.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429729841.121496.15.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Andy Lutomirski <luto@amacapital.net>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jea
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 12:10 PM, Doug Ledford <dledford@redhat.com> wrote:
> On Wed, 2015-04-22 at 21:05 +0200, Luis R. Rodriguez wrote:
>
>> > > I'd also love to remove the driver if it turns out there are actually
>> > > no users. qib substantially replaces it except for a few very old
>> > > cards.
>> >
>> > To be precise, the split is that ipath powers the old HTX bus cards that
>> > only work in AMD systems,
>>
>> Do those systems have PAT support? CAn anyone check if PAT is enabled
>> if booted on a recent kernel?
>
> I don't have one of these systems any more.  The *only* one I ever had
> was a monster IBM box...I can't even find a reference to it any more.

Um, yeah if its so rare then I think the compromise proposed might
make sense, specially since folks were even *considering* seriously
removing this device driver. I'll send some patches to propose the
strategy explained to require booting with pat disabled.

 Luis
