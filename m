From: "Suresh Shelvapille" <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: How to know if SRQ is being used in SRP?
Date: Thu, 5 Aug 2010 12:38:55 -0400
Message-ID: <8BAAFD34FEF6492A8E3B43698E454B3D@md.baymicrosystems.com>
References: <201008031602.37294.bvanassche@acm.org><4C59C34F.2000400@vlnb.net><adak4o66rir.fsf@roland-alpha.cisco.com> <AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikswdOfqoZOmSqmug4ue3KLv3V8NH9W1ME4tnfQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Folks:

I have the envious task of figuring out whether SRQ is being used in an SRP application (which I have very little
knowledge about). I only have IB transport layer traces from the customer. 
>From the traces I can see Valid Credits in the Syndrome field of the AETH in RDMA_ReadResponse_First/last messages.
Although there are a bunch of RC SENDs where the AETH syndrome field is Invalid, unfortunately I cannot seem to
correlate these RC SENDS with the RDMA read/responses. 
My questions is, since the RDMA response AETH field has valid CC credits is it saying SRQ is not being used?

Many thanks,
Suri   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
