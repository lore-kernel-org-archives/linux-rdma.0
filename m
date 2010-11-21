From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Q] I would like to test NFS/RDMA with multiple ports on same fabric
Date: Sun, 21 Nov 2010 19:25:12 +0900
Message-ID: <AANLkTikEpUz5gMr9AbxMBSvpF5S6_Pz8ou2WzE9-taW9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dear members.

I'm newbie about Infiniband.

I would like to test NFS/RDMA on the following environment.
I succeed to setup NFS/RDMA between NFS Server and NFS Client1

Probelm:

  I want to add second NFS client (NFS client2)
  but I can't setup IP over Infiniband between NFS server and NFS client2
  (I don't have Infiniband switch so I want to use multiple ports on
same fabric)

  NFS Serer% ping nfs_client2
  no response

Question:

  (1) Is this environment work fine if I setup correctly??
    ex) I have to change subnet address
        I have to use Infiniband Switch

  (2) What is the problem??

    Could you tell me how to check what is the problem.
    or Please tell me good example if avairable .

Thank you for your information.

Sincrely

--
Hiroyuki Sato.



opensmd
NFS Server
192.168.100.231(port1)
192.168.200.231(port2)        NFS client1(192.168.100.232)
+----------+                  +----------+
|          | 192.168.100.0/24 |          |
|          port1------------port1        |
|          port2--+         port2        |
|          |      |           |          |
+----------+	    |           +----------+
                  |		
      	      	  |
      	      	  |   	      NFS client2(192.168.100.233)
                  |           +----------+
                  |           |          |
                  +----------port1       |
            192.168.200.0/24 port2       |
                              |          |
                              +----------+

Environment
  OS: CentOS 5.5
  Infiniband Card: MHEA28-XTC
  Kernel: 2.6.36


This is ibstat output on NFS Server
# ibstat
CA 'mthca0'
	CA type: MT25208
	Number of ports: 2
	Firmware version: 5.3.0
	Hardware version: a0
	Node GUID: 0x0002c90200220eb8
	System image GUID: 0x0005ad000100d050
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 10
		Base lid: 1
		LMC: 0
		SM lid: 1
		Capability mask: 0x02590a6a
		Port GUID: 0x0002c90200220eb9
		Link layer: IB
	Port 2:
		State: Active
		Physical state: LinkUp
		Rate: 10
		Base lid: 1
		LMC: 0
		SM lid: 3
		Capability mask: 0x02590a68
		Port GUID: 0x0002c90200220eba
		Link layer: IB
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
