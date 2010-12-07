From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Tue, 7 Dec 2010 11:27:39 +0100
Message-ID: <20101207112739.0c95db46@frecb012350.frec.bull.fr>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<4CFD4BEE.5070205@shiftmail.org>
	<20101206212759.GB16788@obsidianresearch.com>
	<20101207083911.2ab47a59@frecb012350.frec.bull.fr>
	<4CFE0638.2040105@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFE0638.2040105-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 7 Dec 2010 12:02:32 +0200
Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> sebastien dugue wrote:
> >   What kind of offload capabilities are you referring to for IPoIB?
> >
> TCP stateless offloads: checksum, LSO, LRO (to be replaced to GRO,=20
> sometime, sooner the better)
>=20
> Or.
>=20

  Huh? How do you do that?

# ethtool -k ib0
Offload parameters for ib0:
rx-checksumming: off
tx-checksumming: off
scatter-gather: off
tcp-segmentation-offload: off
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: off
large-receive-offload: off

# ethtool -K ib0 rx on
Cannot set device rx csum settings: Operation not supported

# ethtool -K ib0 tx on
Cannot set device tx csum settings: Operation not supported

# ethtool -K ib0 sg on
Cannot set device scatter-gather settings: Operation not supported

# ethtool -K ib0 tso on
Cannot set device tcp segmentation offload settings: Operation not supp=
orted

# ethtool -K ib0 lro on
--> Looks like this is the only knob available


# ibstat
CA 'mlx4_0'
	CA type: MT26428
	Number of ports: 2
	Firmware version: 2.7.0
	Hardware version: a0
	Node GUID: 0x0002c90300048914
	System image GUID: 0x0002c90300048917
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 40
		Base lid: 1
		LMC: 0
		SM lid: 1
		Capability mask: 0x0251086a
		Port GUID: 0x0002c90300048915
	Port 2:
		State: Active
		Physical state: LinkUp
		Rate: 40
		Base lid: 9
		LMC: 0
		SM lid: 1
		Capability mask: 0x02510868
		Port GUID: 0x0002c90300048916


  S=C3=A9bastien.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
