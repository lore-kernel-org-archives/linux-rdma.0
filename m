From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sun, 6 Nov 2011 08:34:20 +0100
Message-ID: <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	<CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	<1320516243.5859.184.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 5, 2011 at 7:04 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Sat, 2011-11-05 at 08:37 +0100, Bart Van Assche wrote:
>> On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > This is the PULL request for an initial merge of the ib_srpt drive=
r
>> > using mainline target infrastructure into v3.2-rc1.
>>
>> In case anyone is interested, the most important unaddressed comment=
s
>> for this version of ib_srpt are:
>> - There are still too many module parameters. This makes ib_srpt
>> harder to use than necessary because several of these parameters can
>> only be set at module load time.
>
> Can you be more specific here..? =A0I went through the module paramet=
ers
> and made the ones that where used in a per-port specific context into
> configfs attributes as Roland recommended, but it seems like you are
> saying that more should be made into attributes. =A0Which ones..?

Several read-only kernel module parameters remain. That's fine in
out-of-tree code since it will be compiled as a kernel module only.
But anyone who tries to build with CONFIG_INFINIBAND_SRPT=3Dy will
notice that it's impossible to change the value of these read-only
kernel module parameters.

>> - The last WQE event can arrive before the queue pair is reset,
>> resulting in a hanging session and blocking future logins
>> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09678.htm=
l).
>
> Yep, was going to get this resolved post merge along with my patch no=
w
> in lio-core.git to address active I/O shutdown with ib_srpt.

Your "active I/O shutdown" patch does not address the "last WQE" issue.

>> - The "ib_srpt: Convert srp_max_rdma_size into per port configfs
>> attribute" contradicts the I/O controller concept. This is a bug.
>> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09677.htm=
l).
>
> As mentioned in the thread, I deferred to Roland's input on that one.
> So you're saying this should be made back into a module parameter now=
,
> or what..?

I see two possible ways forward:
- Convert the per-port max_rdma_size configfs variable into a
per-module configfs variable.
- Remove the max_rdma_size variable from configfs entirely and compute
the max_rdma_size from the HCA properties in struct ib_device_attr.

Bart.
