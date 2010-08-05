From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: How to know if SRQ is being used in SRP?
Date: Thu, 05 Aug 2010 11:08:21 -0700
Message-ID: <adavd7p3pbe.fsf@roland-alpha.cisco.com>
References: <201008031602.37294.bvanassche@acm.org>
	<4C59C34F.2000400@vlnb.net> <adak4o66rir.fsf@roland-alpha.cisco.com>
	<AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ@mail.gmail.com>
	<8BAAFD34FEF6492A8E3B43698E454B3D@md.baymicrosystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8BAAFD34FEF6492A8E3B43698E454B3D-+IkoAhRkys/CbFgIbBqbbjGjJy/sRE9J@public.gmane.org> (Suresh
	Shelvapille's message of "Thu, 5 Aug 2010 12:38:55 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  > I have the envious task of figuring out whether SRQ is being used in
  > an SRP application (which I have very little knowledge about). I
  > only have IB transport layer traces from the customer.  From the
  > traces I can see Valid Credits in the Syndrome field of the AETH in
  > RDMA_ReadResponse_First/last messages.  Although there are a bunch
  > of RC SENDs where the AETH syndrome field is Invalid, unfortunately
  > I cannot seem to correlate these RC SENDS with the RDMA
  > read/responses.  My questions is, since the RDMA response AETH field
  > has valid CC credits is it saying SRQ is not being used?

As I guess you know, if end-to-end credits are used on an RC connection,
then SRQ cannot be used on that connection.  The opposite implication
does not hold: eg a TCA might not implement the optional end-to-end flow
control protocol, and hence a non-SRQ connection might still not use
end-to-end flow control.

Also end-to-end flow control is negotiated for each direction of a
connection independently, so you might see valid end-to-end credits sent
in only one direction.

Essentially the only thing you can learn from a wire-level trace is the
following: if you see an AETH with valid end-to-end credits being sent
from CA X, then the corresponding receive queue on CA X is not attached
to an SRQ.  I don't believe there is anything further you can deduce.
(Certainly invalid end-to-end credits do not imply that an SRQ is being
used, they simply imply that the end-to-end flow control protocol is not
in use)

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
