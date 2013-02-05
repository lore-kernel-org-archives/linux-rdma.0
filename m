From: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: "Virtual" ibnetdiscover command fails
Date: Tue, 5 Feb 2013 16:41:35 +0100
Message-ID: <CAOoYFkFw-0WDYt6gQ-t0V6QaV8p7qraYrMbA-NxeiPVfUy2Bkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Or, Jack,

I come back to you because I've another problem when I try to use
virtualization of Infiniband.
My host computer is connected to a cluster through Infiniband. I would
like all the rest of the cluster to communicate with the virtual
machine installed on the host.

I've lauched opensm on the host. All is working well except VM is not
listed when I launched ibnetdiscover on the host.
So I try to launch this last command on the virtual machine, and it
fails with this error :

src/query_smp.c:98; send failed; -5
segment core dump

The sminfo command doesn't work much better on the VM :

ibwarn: [3014] _do_madrpc: send failed; Invalid argument
ibwarn: [3014] mad_rpc: _do_madrpc failed; dport (DR path slid 0; dlid 0; 0)
sminfo: iberror: failed: can't resolve sm port (null)

The result of ibstat (on the virtual machine) :
CA 'mlx4_0'
	CA type: MT4100
	Number of ports: 1
	Firmware version: 2.11.500
	Hardware version: 0
	Node GUID: 0x00140500279a774b
	System image GUID: 0x0002c9030031ff63
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 40
		Base lid: 21
		LMC: 0
		SM lid: 21
		Capability mask: 0x02514868
		Port GUID: 0x0014050000000001
		Link layer: InfiniBand



Have you got any idea about the problem ?

For informations, opensm version is 3.3.15 on both VM and host

Thanks

Mathis
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
