From: Christoph Lameter <cl@linux.com>
Subject: Re: CQ and RDMA READ/WRITE APIs
Date: Tue, 17 May 2016 10:35:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605171031410.25688@east.gentwo.org>
References: <743399f9-10b7-6e62-2bf4-6a8656df8a55@redhat.com> <20160516114926.GA681@lst.de> <f6fdfc59-8193-18ed-0449-a16bba4601e0@redhat.com> <CA+55aFzq+4DJL46B8PXQQG-DpNpzZNzk=O6j+8U_NC6H6BwTdQ@mail.gmail.com> <20160517053852.GA25133@lst.de>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160517053852.GA25133@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 17 May 2016, Christoph Hellwig wrote:

> It's also in entirely new files and not a modification of existing code,
> and it's always been clear how it is.  Some of the code has been in
> since Linux 4.5 with a properly clear copyright.


The problem is that the RDMA subsystem is rather more than a driver. Its a
subsystem that contains drivers.  Dual licensed drivers can use the
features that Christoph provides. This is more infrastructure and thus GPL
I thought.
