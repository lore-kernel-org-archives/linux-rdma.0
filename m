From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH] IB/security: Restrict use of the write() interface
Date: Wed, 18 May 2016 21:59:13 +0300
Message-ID: <CAJ3xEMi0Rg7nc7TN9Hn7=nuWmBZH1qoncKr+HuzjUP=8yMRrDA@mail.gmail.com>
References: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford@redhat.com>
	<20160518172012.GA6879@kroah.com>
	<c6c952ea-3562-48e1-cf56-5b8c810654f1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <c6c952ea-3562-48e1-cf56-5b8c810654f1@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Greg KH <greg@kroah.com>, stable@vger.kernel.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 8:57 PM, Doug Ledford <dledford@redhat.com> wrote:
> On 05/18/2016 01:20 PM, Greg KH wrote:

>> I don't understand, is this only for 3.14.x?

> Yes.

Wait, any reason not to apply it on all stable kernels?

Or.

> You already applied the same patch against 4.5.x, but without the
> update to include the ipath driver and with the hfi1 driver still in the patch.
