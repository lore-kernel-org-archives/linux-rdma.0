From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Fri, 31 May 2019 17:19:55 +0100
Message-ID: <20190531161954.GA3568@arrakis.emea.arm.com>
References: <20190521182932.sm4vxweuwo5ermyd@mbp>
 <201905211633.6C0BF0C2@keescook>
 <6049844a-65f5-f513-5b58-7141588fef2b@oracle.com>
 <20190523201105.oifkksus4rzcwqt4@mbp>
 <ffe58af3-7c70-d559-69f6-1f6ebcb0fec6@oracle.com>
 <20190524101139.36yre4af22bkvatx@mbp>
 <c6dd53d8-142b-3d8d-6a40-d21c5ee9d272@oracle.com>
 <CAAeHK+yAUsZWhp6xPAbWewX5Nbw+-G3svUyPmhXu5MVeEDKYvA@mail.gmail.com>
 <20190530171540.GD35418@arrakis.emea.arm.com>
 <CAAeHK+y34+SNz3Vf+_378bOxrPaj_3GaLCeC2Y2rHAczuaSz1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAAeHK+y34+SNz3Vf+_378bOxrPaj_3GaLCeC2Y2rHAczuaSz1A@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>, Khalid Aziz <khalid.aziz@oracle.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Dmitry Vyukov <dvyukov@google.com>, Dave Martin <Dave.Martin@arm.com>, Evgenii Stepanov <eugenis@google.com>, linux-media@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Yishai Hadas <yis>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 31, 2019 at 04:29:10PM +0200, Andrey Konovalov wrote:
> On Thu, May 30, 2019 at 7:15 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, May 28, 2019 at 04:14:45PM +0200, Andrey Konovalov wrote:
> > > Thanks for a lot of valuable input! I've read through all the replies
> > > and got somewhat lost. What are the changes I need to do to this
> > > series?
> > >
> > > 1. Should I move untagging for memory syscalls back to the generic
> > > code so other arches would make use of it as well, or should I keep
> > > the arm64 specific memory syscalls wrappers and address the comments
> > > on that patch?
> >
> > Keep them generic again but make sure we get agreement with Khalid on
> > the actual ABI implications for sparc.
> 
> OK, will do. I find it hard to understand what the ABI implications
> are. I'll post the next version without untagging in brk, mmap,
> munmap, mremap (for new_address), mmap_pgoff, remap_file_pages, shmat
> and shmdt.

It's more about not relaxing the ABI to accept non-zero top-byte unless
we have a use-case for it. For mmap() etc., I don't think that's needed
but if you think otherwise, please raise it.

> > > 2. Should I make untagging opt-in and controlled by a command line argument?
> >
> > Opt-in, yes, but per task rather than kernel command line option.
> > prctl() is a possibility of opting in.
> 
> OK. Should I store a flag somewhere in task_struct? Should it be
> inheritable on clone?

A TIF flag would do but I'd say leave it out for now (default opted in)
until we figure out the best way to do this (can be a patch on top of
this series).

Thanks.

-- 
Catalin
