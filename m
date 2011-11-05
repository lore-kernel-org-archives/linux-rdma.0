From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sat, 5 Nov 2011 08:37:24 +0100
Message-ID: <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This is the PULL request for an initial merge of the ib_srpt driver
> using mainline target infrastructure into v3.2-rc1.

In case anyone is interested, the most important unaddressed comments
for this version of ib_srpt are:
- There are still too many module parameters. This makes ib_srpt
harder to use than necessary because several of these parameters can
only be set at module load time.
- The last WQE event can arrive before the queue pair is reset,
resulting in a hanging session and blocking future logins
(http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09678.html).
- The "ib_srpt: Convert srp_max_rdma_size into per port configfs
attribute" contradicts the I/O controller concept. This is a bug.
(http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09677.html).

Bart.
