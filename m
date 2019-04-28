From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Sun, 28 Apr 2019 09:59:56 -0700
Message-ID: <CAHk-=wj4ay=jy6wuN4d9p9v+O32i0aH9SMfu39VKP-Ai7hKp=g@mail.gmail.com>
References: <20190428115207.GA11924@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190428115207.GA11924@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 28, 2019 at 4:52 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> Nothing particularly special here. There is a small merge conflict
> with Adrea's mm_still_valid patches which is resolved as below:

I still don't understand *why* you play the crazy VM games to begin with.

What's wrong with just returning SIGBUS? Why does that
rdma_umap_fault() not just look like this one-liner:

        return VM_FAULT_SIGBUS;

without the crazy parts? Nobody ever explained why you'd want to have
that silly "let's turn it into a bogus anonymous mapping".

I've pulled this, but why do the rdma and SCSI people always do these
strange and pointless things?

                  Linus
