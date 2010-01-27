From: Roland Dreier <rdreier@cisco.com>
Subject: Re: infiniband limit of 32 cards per system?
Date: Tue, 26 Jan 2010 16:09:13 -0800
Message-ID: <adaljfko1cm.fsf@roland-alpha.cisco.com>
References: <20100125235013.GD2828@grease.ALLEYCAT>
	<adaiqapplv7.fsf@roland-alpha.cisco.com>
	<20100126220333.GB12035@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755844Ab0A0AJ2@vger.kernel.org>
In-Reply-To: <20100126220333.GB12035@ldl.fc.hp.com> (Alex Chiang's message of
	"Tue, 26 Jan 2010 15:03:33 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


 > It looks like we have a hole from [128, 192).
 > 
 > Would it be something as simple as this?

 > -       IB_UVERBS_BASE_MINOR  = 192,
 > -       IB_UVERBS_MAX_DEVICES = 32
 > +       IB_UVERBS_BASE_MINOR  = 128,
 > +       IB_UVERBS_MAX_DEVICES = 64

I don't think this is a good idea for two reasons:

 - It doesn't take into account the fact that the infiniband_mad and
   infiniband_cm drivers will take up more minors if more devices appear
   (in the best case, you would only be able to run opensm on the first
   32 HCAs or something like that).

 - It changes the minor of the first uverbs device, so something like a
   system with hardcoded static /dev would break in a mysterious way.

I think unfortunately we have to extend the device # assignment so the
first 32 HCAs get the same minors they would have and then overflow into
some dynamic region.

 - R.
