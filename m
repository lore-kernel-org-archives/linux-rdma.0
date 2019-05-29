From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Tue, 28 May 2019 23:11:26 -0700
Message-ID: <20190529061126.GA18124@infradead.org>
References: <20190517144931.GA56186@arrakis.emea.arm.com>
 <CAFKCwrj6JEtp4BzhqO178LFJepmepoMx=G+YdC8sqZ3bcBp3EQ@mail.gmail.com>
 <20190521182932.sm4vxweuwo5ermyd@mbp>
 <201905211633.6C0BF0C2@keescook>
 <6049844a-65f5-f513-5b58-7141588fef2b@oracle.com>
 <20190523201105.oifkksus4rzcwqt4@mbp>
 <ffe58af3-7c70-d559-69f6-1f6ebcb0fec6@oracle.com>
 <20190524101139.36yre4af22bkvatx@mbp>
 <c6dd53d8-142b-3d8d-6a40-d21c5ee9d272@oracle.com>
 <CAAeHK+yAUsZWhp6xPAbWewX5Nbw+-G3svUyPmhXu5MVeEDKYvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeHK+yAUsZWhp6xPAbWewX5Nbw+-G3svUyPmhXu5MVeEDKYvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Evgenii Stepanov <eugenis@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 28, 2019 at 04:14:45PM +0200, Andrey Konovalov wrote:
> Thanks for a lot of valuable input! I've read through all the replies
> and got somewhat lost. What are the changes I need to do to this
> series?
> 
> 1. Should I move untagging for memory syscalls back to the generic
> code so other arches would make use of it as well, or should I keep
> the arm64 specific memory syscalls wrappers and address the comments
> on that patch?

It absolutely needs to move to common code.  Having arch code leads
to pointless (often unintentional) semantic difference between
architectures, and lots of boilerplate code.

Btw, can anyone of the arm crowd or Khalid comment on the linux-mm
thread on generic gup where I'm dealing with the pre-existing ADI
case of pointer untagging?
