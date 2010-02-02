From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH 0/2] Add support for enhanced atomic operations
Date: Tue, 02 Feb 2010 17:13:59 +0100
Message-ID: <42BE52B6-3163-44E0-9FC1-34B753FD7DE1@Sun.com>
References: <4B66FA54.6030408@dev.mellanox.co.il>
 <52BD554704A742B18E3F2F8F2B00B9FE@amr.corp.intel.com>
 <4B68020D.4080401@dev.mellanox.co.il>
 <f0e08f231002020754h482ba0f7xe35a78a72cc165e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <f0e08f231002020754h482ba0f7xe35a78a72cc165e8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Feb 2, 2010, at 16:54 , Hal Rosenstock wrote:

> On Tue, Feb 2, 2010 at 5:44 AM, Vladimir Sokolovsky
>> [snip]
>> Masked Fetch and Add (MFetchAdd)
>> The MFetchAdd Atomic operation extends the functionality of the stan=
dard IB
>> FetchAdd by
>> allowing the user to split the target into multiple fields of select=
able
>> length. The atomic add is done
>> independently on each one of this fields. A bit set in the field_bou=
ndary
>> parameter specifies the
>> field boundaries. The pseudo code below describes the operation:


As discussed by private email, my take is that it is more important to =
support adjacent fields than a single-bit fetch-and-add. Hence, encodin=
g the mask slightly different where a one-to-zero bit transition indica=
tes break-of-carry, but mask-wise treated as a one, allows adjacent bit=
-fields to be added.

Just my two cents.


H=E5kon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
