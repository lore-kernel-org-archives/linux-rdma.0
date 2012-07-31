From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Basics of congestion control?
Date: Tue, 31 Jul 2012 11:37:04 +0200
Message-ID: <5017A740.4020205@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

could someone please explain what I can do with the new congestion cont=
rol?

Do I understand it right that I can influence the flow control (e.g.
amount of credits) with it so that I can avoid disruption (XmitWait,
XmitDiscardedPackets) caused by congestion?

This is at least what we need. ;-)

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Tel.: +49 - 30 - 60 98 56 991 - 915

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
