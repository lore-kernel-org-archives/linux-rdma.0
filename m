From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Sun, 6 Nov 2011 18:42:07 +0100
Message-ID: <CAO+b5-r51b_scUC4bGf_ZGADpLf0W7R1eBXdLW_hxcKApPni1g@mail.gmail.com>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	<CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	<1320516243.5859.184.camel@haakon2.linux-iscsi.org>
	<CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
	<1320574170.5859.370.camel@haakon2.linux-iscsi.org>
	<CAO+b5-p0gLueksp7a8RVm9A1Qe_9xc-fNSNX0NY0W7CNtGnSYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-p0gLueksp7a8RVm9A1Qe_9xc-fNSNX0NY0W7CNtGnSYw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 6, 2011 at 2:20 PM, Bart Van Assche <bvanassche@acm.org> wr=
ote:
> On Sun, Nov 6, 2011 at 11:09 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
>> We have also discussed srpt_service_guid a bit before, which you
>> indicated needed to stay in current code as global scope, and presum=
ably
>> should not change value after loading. =A0Looking at the actual usag=
e, one
>> post merge improvement we can consider is seeing if it's possible to
>> move ib_cm_listen() out of srpt_add_one() and have it driven instead=
 by
>> configfs context in order to optionally set srpt_service_guid on a p=
er
>> target endpoint basis to get us some more flexibility.
>
> ib_sprt defines a single I/O controller profile and hence there shoul=
d
> be exactly one GUID associated with it.

(replying to my own e-mail)

Note: I'm not sure anyone is using the srpt_service_guid kernel module
parameter. One possible approach is to leave out that kernel module
parameter for the initial merge. If later on anyone asks for restoring
that functionality we can evaluate at that time what would be the best
way to restore it.

Bart.
