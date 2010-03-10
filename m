From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH v2 00/15] opensm: torus-2QoS example input files
Date: Wed, 10 Mar 2010 11:12:22 -0700
Message-ID: <1268244742.25886.158.camel@sale659.sandia.gov>
References: <1268244416-20351-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=-A6iiG48MKB0OAzsZBDUd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268244416-20351-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-A6iiG48MKB0OAzsZBDUd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


The attached files can be used to test the torus-2QoS routing
engine using ibsim.

fabric-torus-5x5x5 contains a fabric description that ibsim can read.
Once ibsim is running, run opensm like this:

  opensm --config opensm.conf --torus_config torus-2QoS-5x5x5.conf
or 
  opensm --config opensm.conf --torus_config torus-2QoS-5x5x5.conf \
     -Q --qos_policy_file qos-policy-torus-5x5x5.conf

-- Jim


--=-A6iiG48MKB0OAzsZBDUd
Content-Disposition: attachment;
 filename=fabric-torus-5x5x5.bz2
Content-Type: application/x-bzip;
 name=fabric-torus-5x5x5.bz2
Content-Transfer-Encoding: base64

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


--=-A6iiG48MKB0OAzsZBDUd
Content-Disposition: attachment;
 filename=opensm.conf
Content-Type: text/plain;
 charset=utf-8;
 name=opensm.conf
Content-Transfer-Encoding: 7bit


# Limit the maximal operational VLs
max_op_vls 8

# The number of seconds between subnet sweeps (0 disables it)
sweep_interval 10

# Routing engine
# Multiple routing engines can be specified separated by
# commas so that specific ordering of routing algorithms will
# be tried if earlier routing engines fail.
# Supported engines: minhop, updn, file, ftree, lash, dor
routing_engine torus-2QoS,no_fallback

# Use unicast routing cache (use FALSE if unsure)
use_ucast_cache TRUE

# Force flush of the log file after each log message
force_log_flush TRUE

# Log file to be used
log_file /dev/tty

# console [off|local|loopback|socket]
console loopback

# Telnet port for console (default 10000)
console_port 10000

# QoS default options
# Note that for OFED > 1.3, this information can also be in qos-policy.conf.
# However, it may be good to have it here also for torus-2QoS, as this will
# change the defaults even if not using QoS.
qos_max_vls 8
qos_high_limit 0
qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0
qos_vlarb_low 0:64,1:64,2:64,3:64,4:64,5:64,6:64,7:64,8:64
qos_sl2vl (null)

--=-A6iiG48MKB0OAzsZBDUd
Content-Disposition: attachment;
 filename=qos-policy-torus-5x5x5.conf
Content-Type: text/plain;
 charset=utf-8;
 name=qos-policy-torus-5x5x5.conf
Content-Transfer-Encoding: 7bit


# This is a QoS configuration for the torus-2QoS routing engine.
# As it supports only 2 levels of QoS, via SL bit 3, we should configure
# only SLs 0 and 8.  Based on that torus-2QoS will pick the appropriate
# SL value to provide deadlock-free routing for both QoS levels.

port-groups
    port-group
	name: Service_nodes
	port-name: "H_0_0_0_0/P1"	# E.g. admin
	port-name: "H_0_0_1_0/P1"	# E.g. NFS server
	port-name: "H_0_0_2_0/P1"	# E.g. boot server
	port-name: "H_0_0_3_0/P1"	# E.g. login node
    end-port-group

    port-group
	name: Lustre_nodes

	port-name: "H_0_0_4_0/P1"	# E.g. MDS

	port-name: "H_0_1_0_0/P1"	# E.g. OSS
	port-name: "H_0_1_1_0/P1"	# E.g. OSS
	port-name: "H_0_1_2_0/P1"	# E.g. OSS
	port-name: "H_0_1_3_0/P1"	# E.g. OSS
	port-name: "H_0_1_4_0/P1"	# E.g. OSS
    end-port-group

    port-group
	name: Compute_nodes

	port-name: "H_0_2_0_0/P1"
	port-name: "H_0_2_1_0/P1"
	port-name: "H_0_2_2_0/P1"
	port-name: "H_0_2_3_0/P1"
	port-name: "H_0_2_4_0/P1"

	port-name: "H_0_3_0_0/P1"
	port-name: "H_0_3_1_0/P1"
	port-name: "H_0_3_2_0/P1"
	port-name: "H_0_3_3_0/P1"
	port-name: "H_0_3_4_0/P1"

	port-name: "H_0_4_0_0/P1"
	port-name: "H_0_4_1_0/P1"
	port-name: "H_0_4_2_0/P1"
	port-name: "H_0_4_3_0/P1"
	port-name: "H_0_4_4_0/P1"

	port-name: "H_1_0_0_0/P1"
	port-name: "H_1_0_1_0/P1"
	port-name: "H_1_0_2_0/P1"
	port-name: "H_1_0_3_0/P1"
	port-name: "H_1_0_4_0/P1"

	port-name: "H_1_1_0_0/P1"
	port-name: "H_1_1_1_0/P1"
	port-name: "H_1_1_2_0/P1"
	port-name: "H_1_1_3_0/P1"
	port-name: "H_1_1_4_0/P1"

	port-name: "H_1_2_0_0/P1"
	port-name: "H_1_2_1_0/P1"
	port-name: "H_1_2_2_0/P1"
	port-name: "H_1_2_3_0/P1"
	port-name: "H_1_2_4_0/P1"

	port-name: "H_1_3_0_0/P1"
	port-name: "H_1_3_1_0/P1"
	port-name: "H_1_3_2_0/P1"
	port-name: "H_1_3_3_0/P1"
	port-name: "H_1_3_4_0/P1"

	port-name: "H_1_4_0_0/P1"
	port-name: "H_1_4_1_0/P1"
	port-name: "H_1_4_2_0/P1"
	port-name: "H_1_4_3_0/P1"
	port-name: "H_1_4_4_0/P1"

	port-name: "H_2_0_0_0/P1"
	port-name: "H_2_0_1_0/P1"
	port-name: "H_2_0_2_0/P1"
	port-name: "H_2_0_3_0/P1"
	port-name: "H_2_0_4_0/P1"

	port-name: "H_2_1_0_0/P1"
	port-name: "H_2_1_1_0/P1"
	port-name: "H_2_1_2_0/P1"
	port-name: "H_2_1_3_0/P1"
	port-name: "H_2_1_4_0/P1"

	port-name: "H_2_2_0_0/P1"
	port-name: "H_2_2_1_0/P1"
	port-name: "H_2_2_2_0/P1"
	port-name: "H_2_2_3_0/P1"
	port-name: "H_2_2_4_0/P1"

	port-name: "H_2_3_0_0/P1"
	port-name: "H_2_3_1_0/P1"
	port-name: "H_2_3_2_0/P1"
	port-name: "H_2_3_3_0/P1"
	port-name: "H_2_3_4_0/P1"

	port-name: "H_2_4_0_0/P1"
	port-name: "H_2_4_1_0/P1"
	port-name: "H_2_4_2_0/P1"
	port-name: "H_2_4_3_0/P1"
	port-name: "H_2_4_4_0/P1"

	port-name: "H_3_0_0_0/P1"
	port-name: "H_3_0_1_0/P1"
	port-name: "H_3_0_2_0/P1"
	port-name: "H_3_0_3_0/P1"
	port-name: "H_3_0_4_0/P1"

	port-name: "H_3_1_0_0/P1"
	port-name: "H_3_1_1_0/P1"
	port-name: "H_3_1_2_0/P1"
	port-name: "H_3_1_3_0/P1"
	port-name: "H_3_1_4_0/P1"

	port-name: "H_3_2_0_0/P1"
	port-name: "H_3_2_1_0/P1"
	port-name: "H_3_2_2_0/P1"
	port-name: "H_3_2_3_0/P1"
	port-name: "H_3_2_4_0/P1"

	port-name: "H_3_3_0_0/P1"
	port-name: "H_3_3_1_0/P1"
	port-name: "H_3_3_2_0/P1"
	port-name: "H_3_3_3_0/P1"
	port-name: "H_3_3_4_0/P1"

	port-name: "H_4_4_0_0/P1"
	port-name: "H_4_4_1_0/P1"
	port-name: "H_4_4_2_0/P1"
	port-name: "H_4_4_3_0/P1"
	port-name: "H_4_4_4_0/P1"

	port-name: "H_4_0_0_0/P1"
	port-name: "H_4_0_1_0/P1"
	port-name: "H_4_0_2_0/P1"
	port-name: "H_4_0_3_0/P1"
	port-name: "H_4_0_4_0/P1"

	port-name: "H_4_1_0_0/P1"
	port-name: "H_4_1_1_0/P1"
	port-name: "H_4_1_2_0/P1"
	port-name: "H_4_1_3_0/P1"
	port-name: "H_4_1_4_0/P1"

	port-name: "H_4_2_0_0/P1"
	port-name: "H_4_2_1_0/P1"
	port-name: "H_4_2_2_0/P1"
	port-name: "H_4_2_3_0/P1"
	port-name: "H_4_2_4_0/P1"

	port-name: "H_4_3_0_0/P1"
	port-name: "H_4_3_1_0/P1"
	port-name: "H_4_3_2_0/P1"
	port-name: "H_4_3_3_0/P1"
	port-name: "H_4_3_4_0/P1"

	port-name: "H_4_4_0_0/P1"
	port-name: "H_4_4_1_0/P1"
	port-name: "H_4_4_2_0/P1"
	port-name: "H_4_4_3_0/P1"
	port-name: "H_4_4_4_0/P1"
    end-port-group

    port-group
	name: All_ports
	node-type: ALL
    end-port-group
end-port-groups

#
# The default VL arbitration setup will not be quite right for
# torus-2QoS, so set up something more appropriate.
#
# All the SLs for a given QoS level need to have equal traffic priority.
# Since SLs 0-7 map to VLs 0-3, and SLs 8-15 map to VLs 4-7, we need 
# equal VL arbitration weightings in each of those VL ranges.
#
# OFED 1.3 doesn't use this information, just parses and drops it on the floor,
# so it needs to be repeated in opensm.conf.  Putting it in opensm.conf has
# the added benefit that the defaults can be set and used even if QoS isn't
# configured.
#
qos-setup
    vlarb-tables
	vlarb-scope
	    group: All_ports
	    across: All_ports

	    vl-high-limit: 0

	    vlarb-high: 0:0
	    vlarb-high: 1:0
	    vlarb-high: 2:0
	    vlarb-high: 3:0
	    vlarb-high: 4:0
	    vlarb-high: 5:0
	    vlarb-high: 6:0
	    vlarb-high: 7:0
	    vlarb-high: 8:0
	    vlarb-high: 9:0
	    vlarb-high: 10:0
	    vlarb-high: 11:0
	    vlarb-high: 12:0
	    vlarb-high: 13:0
	    vlarb-high: 14:0

	    vlarb-low: 0:64
	    vlarb-low: 1:64
	    vlarb-low: 2:64
	    vlarb-low: 3:64
	    vlarb-low: 4:64
	    vlarb-low: 5:64
	    vlarb-low: 6:64
	    vlarb-low: 7:64
	    vlarb-low: 8:64
	    vlarb-low: 9:64
	    vlarb-low: 10:64
	    vlarb-low: 11:64
	    vlarb-low: 12:64
	    vlarb-low: 13:64
	    vlarb-low: 14:64
	end-vlarb-scope
    end-vlarb-tables
end-qos-setup

#
# We don't explicitly use the qos-class keyword in qos-match-rule, because
# we don't have any control over how apps will specify qos-class in path
# queries, and we don't want rule matching falures due to wrong qos-class
# values in queries.
#
qos-levels
    qos-level
	name: DEFAULT
	sl: 0
    end-qos-level

    # By assigning Lustre and MPI traffic to different SLs (and thus 
    # different VLs) we keep MPI and Lustre from starving each other.
    qos-level
	name: Lustre
	sl: 0
    end-qos-level

    qos-level
	name: MPI
	sl: 8
    end-qos-level
end-qos-levels

#
# For the purposes of QoS configuration, MPI is not a supported ULP.
# Need to use port group match rules get MPI to request SL 8.
#
qos-ulps
    ipoib : 0
    default : 0
end-qos-ulps

#
# Note that the first matching rule is used to assign the qos-level-name
# used to chose the SL to send on, and that anything that doesn't match
# one of the above rules will be assigned to the DEFAULT qos-level.
#
qos-match-rules
    qos-match-rule
	source: Compute_nodes
	destination: Compute_nodes
	qos-level-name: MPI
    end-qos-match-rule

    qos-match-rule
	source: Lustre_nodes
	qos-level-name: Lustre
    end-qos-match-rule

    qos-match-rule
	destination: Lustre_nodes
	qos-level-name: Lustre
    end-qos-match-rule

    # Note that anything that doesn't match one of the above rules
    # will be assigned to the DEFAULT qos-level.
end-qos-match-rules

--=-A6iiG48MKB0OAzsZBDUd
Content-Disposition: attachment;
 filename=torus-2QoS-5x5x5.conf
Content-Type: text/plain;
 charset=utf-8;
 name=torus-2QoS-5x5x5.conf
Content-Transfer-Encoding: 7bit

# We want the torus routing engine to attempt to find a
# 5x5x5 torus in the fabric:
torus 5 5 5

# We need to tell the routing engine what directions we
# want the torus coordinate directions to be, by specifing
# the endpoints (switch GUID + port) of a link in each
# direction. These links need to share a common switch,
# which we call the torus seed.
# Here we specify positive coordinate directions:
xp_link 0x200000  0x200019   # S_0_0_0 -> S_1_0_0
yp_link 0x200000  0x200005   # S_0_0_0 -> S_0_1_0
zp_link 0x200000  0x200001   # S_0_0_0 -> S_0_0_1

# If one of the above switches were to fail, the routing
# engine would not have sufficient information to locate the
# torus in the fabric.  Specify a backup seed here:

next_seed
xp_link 0x20001f  0x200038   # S_1_1_1 -> S_2_1_1
yp_link 0x20001f  0x200024   # S_1_1_1 -> S_1_2_1
zp_link 0x20001f  0x200020   # S_1_1_1 -> S_1_1_2

# The torus routing engine uses the concept of a dateline,
# where a coordinate wraps from its maximum back to zero,
# in order to compute path SL values that provide routing
# that is free from credit loops.
#
# If it is forced by a failed switch to use the backup
# seed specification, that would cause the datelines
# to move, which would change many path SL values, and
# defeats one of the main benefits of this routing engine.
# So, describe the position of the original datelines
# relative to the backup seed as follows:
x_dateline -1
y_dateline -1
z_dateline -1

# You can specify as many backup seeds as you like, but
# in practice, the torus routing engine is only guaranteed
# to be able to route around a single failed switch without
# introducing credit loops, so one backup seed is enough.

--=-A6iiG48MKB0OAzsZBDUd--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
