From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v16 02/16] arm64: untag user pointers in access_ok and
 __uaccess_mask_ptr
Date: Wed, 12 Jun 2019 12:04:44 +0100
Message-ID: <20190612110443.GD28951@C02TF0J2HF1T.local>
References: <cover.1559580831.git.andreyknvl@google.com>
 <4327b260fb17c4776a1e3c844f388e4948cfb747.1559580831.git.andreyknvl@google.com>
 <20190610175326.GC25803@arrakis.emea.arm.com>
 <20190611145720.GA63588@arrakis.emea.arm.com>
 <CAAeHK+z5nSOOaGfehETzznNcMq5E5U+Eb1rZE16UVsT8FWT0Vg@mail.gmail.com>
 <20190611173903.4icrfmoyfvms35cy@mbp>
 <CAAeHK+ysoiCSiCNrrvXqffK53WwBMHbc3bk69uU0vY0+R4_JvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeHK+ysoiCSiCNrrvXqffK53WwBMHbc3bk69uU0vY0+R4_JvQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>, Khalid Aziz <khalid.aziz@oracle.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dmitry Vyukov <dvyukov@google.com>, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, linux-media@vger.kerne
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2019 at 01:03:10PM +0200, Andrey Konovalov wrote:
> On Tue, Jun 11, 2019 at 7:39 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Jun 11, 2019 at 07:09:46PM +0200, Andrey Konovalov wrote:
> > > Should I drop access_ok() change from my patch, since yours just reverts it?
> >
> > Not necessary, your patch just relaxes the ABI for all apps, mine
> > tightens it. You could instead move the untagging to __range_ok() and
> > rebase my patch accordingly.
> 
> OK, will do. I'll also add a comment next to TIF_TAGGED_ADDR as Vincenzo asked.

Thanks.

-- 
Catalin
