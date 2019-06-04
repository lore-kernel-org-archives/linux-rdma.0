From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v16 01/16] uaccess: add untagged_addr definition for other arches
Date: Tue, 4 Jun 2019 13:45:24 +0200
Message-ID: <CAAeHK+wccK1upfOWxNbZBR0BUWT23VFUFEqRTEp3H+8hXN8yzw@mail.gmail.com>
References: <cover.1559580831.git.andreyknvl@google.com> <097bc300a5c6554ca6fd1886421bb2e0adb03420.1559580831.git.andreyknvl@google.com>
 <8ff5b0ff-849a-1e0b-18da-ccb5be85dd2b@oracle.com> <CAAeHK+xX2538e674Pz25unkdFPCO_SH0pFwFu=8+DS7RzfYnLQ@mail.gmail.com>
 <f6711d31-e52c-473a-d7ad-b2d63131d7a5@oracle.com> <20190603172916.GA5390@infradead.org>
 <7a687a26-fc3e-2caa-1d6a-464f1f7e684c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7a687a26-fc3e-2caa-1d6a-464f1f7e684c@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 3, 2019 at 8:17 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
>
> On 6/3/19 11:29 AM, Christoph Hellwig wrote:
> > On Mon, Jun 03, 2019 at 11:24:35AM -0600, Khalid Aziz wrote:
> >> On 6/3/19 11:06 AM, Andrey Konovalov wrote:
> >>> On Mon, Jun 3, 2019 at 7:04 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
> >>>> Andrey,
> >>>>
> >>>> This patch has now become part of the other patch series Chris Hellwig
> >>>> has sent out -
> >>>> <https://lore.kernel.org/lkml/20190601074959.14036-1-hch@lst.de/>. Can
> >>>> you coordinate with that patch series?
> >>>
> >>> Hi!
> >>>
> >>> Yes, I've seen it. How should I coordinate? Rebase this series on top
> >>> of that one?
> >>
> >> That would be one way to do it. Better yet, separate this patch from
> >> both patch series, make it standalone and then rebase the two patch
> >> series on top of it.
> >
> > I think easiest would be to just ask Linus if he could make an exception
> > and include this trivial prep patch in 5.2-rc.
> >
>
> Andrey,
>
> Would you mind updating the commit log to make it not arm64 specific and
> sending this patch out by itself. We can then ask Linus if he can
> include just this patch in the next rc.

Sure! Just sent it out.

>
> Thanks,
> Khalid
>
