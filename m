From: "Paul Grun" <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Thu, 4 Feb 2010 16:03:04 -0800
Message-ID: <002401caa5f6$97c79de0$c756d9a0$@com>
References: <4B6B47D0.9030507@aoot.com>	<DE586AB7003E4FC4B3850004A0B3CAF6@amr.corp.intel.com>	<4B6B4C9B.8070804@opengridcomputing.com>	<EEF75E01C32544C688989E66FECDC422@amr.corp.intel.com>	<4B6B4EFE.3010205@opengridcomputing.com>	<DB361897EE7C40C5AB494AAC2D8625AC@amr.corp.intel.com>	<4B6B5277.80307@opengridcomputing.com>	<aday6j8efqs.fsf@roland-alpha.cisco.com>	<4B6B5BD7.9090301@opengridcomputing.com>
	<adatytwef1i.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <adatytwef1i.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-us
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'OpenFabrics EWG' <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I can.  Chapter 17 verse 3.1

17.3.1 Loopback
"An HCA shall be able to internally loopback a packet sent to itself. That
is,
the verbs layer can specify a packet to be delivered to the same port
(possibly
a different QP though). The packet shall be delivered without the
packet appearing on the port's physical link. This loopback shall be able
to function without requiring the presence of an external switch.
InfiniBand does not reserve a special LID value to indicate loopback.
Instead,
the DLID (and DGID if present) of a loopback packet should be the
LID (and GID) of the port on which the packet was emitted. For loopback
packets, a channel adapter implementation may ignore other path information,
such as MTU, that is not otherwise needed for the receive buffer
or for the completion queue as specified in section 11.4.2.1 Poll for
Completion
on page 629."

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Thursday, February 04, 2010 3:51 PM
To: Steve Wise
Cc: Sean Hefty; linux-rdma; OpenFabrics EWG; Jeff Squyres
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes

 > Is this only an iwarp issue?  IE do all IB devices support hw
 > loopback?  And will all future devices support it (IE is it an IBTA
 > requirement)?

I do think IBA requires loopback to work.  Can't quote chapter & verse
off the top of my head.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cisco.com - http://www.cisco.com

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
