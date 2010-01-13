From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 0/3] Add support for specific Lustre Qos
Date: Wed, 13 Jan 2010 15:49:52 +0100
Message-ID: <20100113154952.0f01aa1d@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  These patches allow to have a specific QoS for Lustre traffic.

   - Patch 1 adds a new Lustre port space to the rdma_cm kernel module

   - Patch 2 defines a new Lustre service ID (matching the new RDMA CMA=
 port
     space) and a new 'lustre' keyword in the OpenSM QoS policy parser.

   - Patch 3 adds a new port_space parameter for the Lustre ko2iblnd ke=
rnel
     module that allows to specify the port space to be used by LNET. T=
his
     patch has already been submitted to the Lustre community and is on=
ly
     given here as a reference. The relevant discussion is at
     https://bugzilla.lustre.org/show_bug.cgi?id=3D21732

  In order the exercise QoS using this Lustre port space, the following=
 setup
may be used:

  1. OpenSM configuration - etc/opensm/opensm.conf

    #
    #=C2=A0QoS=C2=A0OPTIONS
    #
    #=C2=A0Enable=C2=A0QoS=C2=A0setup
    qos=C2=A0TRUE
    #=C2=A0QoS=C2=A0policy=C2=A0file=C2=A0to=C2=A0be=C2=A0used
    qos_policy_file=C2=A0/etc/opensm/qos=C2=ADpolicy.conf
    #=C2=A0QoS=C2=A0default=C2=A0options
    qos_max_vls=C2=A0=C2=A0=C2=A0=C2=A08
    qos_high_limit=C2=A01
    qos_vlarb_high=C2=A00:0,1:0,2:0,3:0,4:0,5:0
    qos_vlarb_low=C2=A0=C2=A00:1,1:16,2:32,3:64,4:1,5:0
    qos_sl2vl=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00,1,2,3,4,5,6,7,8,9,10=
,11,12,13,14,15

    The VLARB weights are only indicative.


  2. OpenSM QoS policy configuration - /etc/opensm/qos-policy.conf:

    qos=C2=ADulps=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0default=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0	:=C2=A00=C2=A0#=C2=A0default=C2=A0SL
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lustre,=C2=A0target=C2=AD=
port=C2=ADguid=C2=A00x1234=C2=A0:=C2=A01=C2=A0#=C2=A0lustre=C2=A0traffi=
c to a specific
					    # port guid (ex MDS traffic)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lustre=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0	:=C2=A02=C2=A0#=C2=A0lustre default traffic
    end=C2=ADqos=C2=ADulps=C2=A0

  3. Lustre module configuration - /etc/modprobe.d/lustre.conf

     Add the following line to all the Lustre nodes:

     options=C2=A0ko2iblnd=C2=A0port_space=3D339


  Sebastien.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
