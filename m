From: "Jaszcza, Andrzej" <andrzej.jaszcza-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Intel NetEffect NE020 E10G81GP use
Date: Wed, 15 Dec 2010 21:45:48 +0000
Message-ID: <70B82AB4096EC24DAE01A7202D27B68B010B6D4819@irsmsx503.ger.corp.intel.com>
References: <4438953.1292407689320.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4438953.1292407689320.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Andrea,

I think you meant RDMA over TCP/IP (iWarp) and not RDMA over Converged Ethernet (RoCE) as Intel NetEffect cards do not support the latter. You may safely try to run any MPI benchmarks using MVAPICH2, Open MPI or Intel MPI. There is more information on iWarp, Intel NetEffect cards and their possible uses on Intel website: http://www.intel.com/technology/comms/iwarp/index.htm.

Regards,
Andrzej

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Andrea Gozzelino
Sent: Wednesday, December 15, 2010 11:08 AM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Intel NetEffect NE020 E10G81GP use
Importance: High

Hi all,

I have tested two cards Intel NetEffect NE020 E10G81GP with RDMA over
Ethernet; results are OK in latency and bandwidth.
Are there other protocols supported by cards,that offer the same
performances?
(TCP Offload, STORAGE, MPI). 
Socket Direct Protocol (SDO) is not good for those performances. 
Any suggestions about using cards with high performances?
What are benefits using these cards in daily storage and data movement
operations?

Thank you.
Best regards,

Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552				

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
