From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc infrastructure bits
Date: Fri, 14 Oct 2016 15:21:34 -0400
Message-ID: <20161014192136.11731-3-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Red Hat has been shipping an "rdma" package, as well as it's own systemd
unit files for some daemons for a while now, in both Fedora and Red Hat
Enterprise Linux. Some of these are fairly RH-specific, but might be of
use to others, so we'd like to move them into the upstream source tree.

Most of these were authored by Doug Ledford, though I'm currently the one
that maintains (most of) them in RHEL.

CC: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 glue/redhat/ibacm.service                |  12 ++
 glue/redhat/iwpmd.service                |  12 ++
 glue/redhat/rdma.conf                    |  25 +++
 glue/redhat/rdma.cxgb3.sys.modprobe      |   1 +
 glue/redhat/rdma.cxgb4.sys.modprobe      |   1 +
 glue/redhat/rdma.fixup-mtrr.awk          | 160 ++++++++++++++++
 glue/redhat/rdma.ifdown-ib               | 183 ++++++++++++++++++
 glue/redhat/rdma.ifup-ib                 | 308 +++++++++++++++++++++++++++++++
 glue/redhat/rdma.kernel-init             | 262 ++++++++++++++++++++++++++
 glue/redhat/rdma.mlx4-setup.sh           |  91 +++++++++
 glue/redhat/rdma.mlx4.conf               |  27 +++
 glue/redhat/rdma.mlx4.sys.modprobe       |   5 +
 glue/redhat/rdma.mlx4.user.modprobe      |  21 +++
 glue/redhat/rdma.modules-setup.sh        |  30 +++
 glue/redhat/rdma.service                 |  15 ++
 glue/redhat/rdma.sriov-init              | 137 ++++++++++++++
 glue/redhat/rdma.sriov-vfs               |  41 ++++
 glue/redhat/rdma.udev-ipoib-naming.rules |  13 ++
 glue/redhat/rdma.udev-rules              |  18 ++
 glue/redhat/srp_daemon.service           |  17 ++
 20 files changed, 1379 insertions(+)
 create mode 100644 glue/redhat/ibacm.service
 create mode 100644 glue/redhat/iwpmd.service
 create mode 100644 glue/redhat/rdma.conf
 create mode 100644 glue/redhat/rdma.cxgb3.sys.modprobe
 create mode 100644 glue/redhat/rdma.cxgb4.sys.modprobe
 create mode 100644 glue/redhat/rdma.fixup-mtrr.awk
 create mode 100644 glue/redhat/rdma.ifdown-ib
 create mode 100644 glue/redhat/rdma.ifup-ib
 create mode 100644 glue/redhat/rdma.kernel-init
 create mode 100644 glue/redhat/rdma.mlx4-setup.sh
 create mode 100644 glue/redhat/rdma.mlx4.conf
 create mode 100644 glue/redhat/rdma.mlx4.sys.modprobe
 create mode 100644 glue/redhat/rdma.mlx4.user.modprobe
 create mode 100644 glue/redhat/rdma.modules-setup.sh
 create mode 100644 glue/redhat/rdma.service
 create mode 100644 glue/redhat/rdma.sriov-init
 create mode 100644 glue/redhat/rdma.sriov-vfs
 create mode 100644 glue/redhat/rdma.udev-ipoib-naming.rules
 create mode 100644 glue/redhat/rdma.udev-rules
 create mode 100644 glue/redhat/srp_daemon.service

diff --git a/glue/redhat/ibacm.service b/glue/redhat/ibacm.service
new file mode 100644
index 0000000..1cd031a
--- /dev/null
+++ b/glue/redhat/ibacm.service
@@ -0,0 +1,12 @@
+[Unit]
+Description=Starts the InfiniBand Address Cache Manager daemon
+Documentation=man:ibacm
+Requires=rdma.service
+After=rdma.service opensm.service
+
+[Service]
+Type=forking
+ExecStart=/usr/sbin/ibacm
+
+[Install]
+WantedBy=network.target
diff --git a/glue/redhat/iwpmd.service b/glue/redhat/iwpmd.service
new file mode 100644
index 0000000..ff19acd
--- /dev/null
+++ b/glue/redhat/iwpmd.service
@@ -0,0 +1,12 @@
+[Unit]
+Description=Starts the IWPMD daemon
+Documentation=file:///usr/share/doc/iwpmd/README
+After=network.target syslog.target
+
+[Service]
+Type=simple
+LimitNOFILE=102400
+ExecStart=/usr/bin/iwpmd
+
+[Install]
+WantedBy=multi-user.target
diff --git a/glue/redhat/rdma.conf b/glue/redhat/rdma.conf
new file mode 100644
index 0000000..9446564
--- /dev/null
+++ b/glue/redhat/rdma.conf
@@ -0,0 +1,25 @@
+# Load IPoIB
+IPOIB_LOAD=yes
+# Load SRP (SCSI Remote Protocol initiator support) module
+SRP_LOAD=yes
+# Load SRPT (SCSI Remote Protocol target support) module
+SRPT_LOAD=yes
+# Load iSER (iSCSI over RDMA initiator support) module
+ISER_LOAD=yes
+# Load iSERT (iSCSI over RDMA target support) module
+ISERT_LOAD=yes
+# Load RDS (Reliable Datagram Service) network protocol
+RDS_LOAD=no
+# Load NFSoRDMA client transport module
+XPRTRDMA_LOAD=yes
+# Load NFSoRDMA server transport module
+SVCRDMA_LOAD=no
+# Load Tech Preview device driver modules
+TECH_PREVIEW_LOAD=no
+# Should we modify the system mtrr registers?  We may need to do this if you
+# get messages from the ib_ipath driver saying that it couldn't enable
+# write combining for the PIO buffs on the card.
+#
+# Note: recent kernels should do this for us, but in case they don't, we'll
+# leave this option
+FIXUP_MTRR_REGS=no
diff --git a/glue/redhat/rdma.cxgb3.sys.modprobe b/glue/redhat/rdma.cxgb3.sys.modprobe
new file mode 100644
index 0000000..d5925a7
--- /dev/null
+++ b/glue/redhat/rdma.cxgb3.sys.modprobe
@@ -0,0 +1 @@
+install cxgb3 /sbin/modprobe --ignore-install cxgb3 $CMDLINE_OPTS && /sbin/modprobe iw_cxgb3
diff --git a/glue/redhat/rdma.cxgb4.sys.modprobe b/glue/redhat/rdma.cxgb4.sys.modprobe
new file mode 100644
index 0000000..44163ab
--- /dev/null
+++ b/glue/redhat/rdma.cxgb4.sys.modprobe
@@ -0,0 +1 @@
+install cxgb4 /sbin/modprobe --ignore-install cxgb4 $CMDLINE_OPTS && /sbin/modprobe iw_cxgb4
diff --git a/glue/redhat/rdma.fixup-mtrr.awk b/glue/redhat/rdma.fixup-mtrr.awk
new file mode 100644
index 0000000..a57ca76
--- /dev/null
+++ b/glue/redhat/rdma.fixup-mtrr.awk
@@ -0,0 +1,160 @@
+# This is a simple script that checks the contents of /proc/mtrr to see if
+# the BIOS maker for the computer took the easy way out in terms of
+# specifying memory regions when there is a hole below 4GB for PCI access
+# and the machine has 4GB or more of RAM.  When the contents of /proc/mtrr
+# show a 4GB mapping of write-back cached RAM, minus punch out hole(s) of
+# uncacheable regions (the area reserved for PCI access), then it becomes
+# impossible for the ib_ipath driver to set write_combining on its PIO
+# buffers.  To correct the problem, remap the lower memory region in various
+# chunks up to the start of the punch out hole(s), then delete the punch out
+# hole(s) entirely as they aren't needed any more.  That way, ib_ipath will
+# be able to set write_combining on its PIO memory access region.
+
+BEGIN {
+	regs = 0
+}
+
+function check_base(mem)
+{
+	printf "Base memory data: base=0x%08x, size=0x%x\n", base[mem], size[mem] > "/dev/stderr"
+	if (size[mem] < (512 * 1024 * 1024))
+		return 0
+	if (type[mem] != "write-back")
+		return 0
+	if (base[mem] >= (4 * 1024 * 1024 * 1024))
+		return 0
+	return 1
+}
+
+function check_hole(hole)
+{
+	printf "Hole data: base=0x%08x, size=0x%x\n", base[hole], size[hole] > "/dev/stderr"
+	if (size[hole] > (1 * 1024 * 1024 * 1024))
+		return 0
+	if (type[hole] != "uncachable")
+		return 0
+	if ((base[hole] + size[hole]) > (4 * 1024 * 1024 * 1024))
+		return 0
+	return 1
+}
+
+function build_entries(start, end,     new_base, new_size, tmp_base)
+{
+	# mtrr registers require alignment of blocks, so a 256MB chunk must
+	# be 256MB aligned.  Additionally, all blocks must be a power of 2
+	# in size.  So, do the largest power of two size that we can and
+	# still have start + block <= end, rinse and repeat.
+	tmp_base = start
+	do {
+		new_base = tmp_base
+		new_size = 4096
+		while (((new_base + new_size) < end) &&
+		       ((new_base % new_size) == 0))
+			new_size = lshift(new_size, 1)
+		if (((new_base + new_size) > end) ||
+		    ((new_base % new_size) != 0))
+			new_size = rshift(new_size, 1)
+		printf "base=0x%x size=0x%x type=%s\n",
+			new_base, new_size, type[mem] > "/dev/stderr"
+		printf "base=0x%x size=0x%x type=%s\n",
+			new_base, new_size, type[mem] > "/proc/mtrr"
+		fflush("")
+		tmp_base = new_base + new_size
+	} while (tmp_base < end)
+}
+
+{
+	gsub("^reg", "")
+	gsub(": base=", " ")
+	gsub(" [(].*), size=", " ")
+	gsub(": ", " ")
+	gsub(", count=.*$", "")
+	register[regs] = strtonum($1)
+	base[regs] = strtonum($2)
+	size[regs] = strtonum($3)
+	human_size[regs] = size[regs]
+	if (match($3, "MB")) { size[regs] *= 1024*1024; mult[regs] = "MB" }
+	else { size[regs] *= 1024; mult[regs] = "KB" }
+	type[regs] = $4
+	enabled[regs] = 1
+	end[regs] = base[regs] + size[regs]
+	regs++
+}
+
+END {
+	# First we need to find our base memory region.  We only care about
+	# the memory register that starts at base 0.  This is the only one
+	# that we can reliably know is our global memory region, and the
+	# only one that we can reliably check against overlaps.  It's entirely
+	# possible that any memory region not starting at 0 and having an
+	# overlap with another memory region is in fact intentional and we
+	# shouldn't touch it.
+	for(i=0; i<regs; i++)
+		if (base[i] == 0)
+			break
+	# Did we get a valid base register?
+	if (i == regs)
+		exit 1
+	mem = i
+	if (!check_base(mem))
+		exit 1
+
+	cur_hole = 0
+	for(i=0; i<regs; i++) {
+		if (i == mem)
+			continue
+		if (base[i] < end[mem] && check_hole(i))
+			holes[cur_hole++] = i
+	}
+	if (cur_hole == 0) {
+		print "Nothing to do" > "/dev/stderr"
+		exit 1
+	}
+	printf "Found %d punch-out holes\n", cur_hole > "/dev/stderr"
+
+	# We need to sort the holes according to base address
+	for(j = 0; j < cur_hole - 1; j++) {
+		for(i = cur_hole - 1; i > j; i--) {
+			if(base[holes[i]] < base[holes[i-1]]) {
+				tmp = holes[i]
+				holes[i] = holes[i-1]
+				holes[i-1] = tmp
+			}
+		}
+	}
+	# OK, the common case would be that the BIOS is mapping holes out
+	# of the 4GB memory range, and that our hole(s) are consecutive and
+	# that our holes and our memory region end at the same place.  However,
+	# things like machines with 8GB of RAM or more can foul up these
+	# common traits.
+	#
+	# So, our modus operandi is to disable all of the memory/hole regions
+	# to start, then build new base memory zones that in the end add
+	# up to the same as our original zone minus the holes.  We know that
+	# we will never have a hole listed here that belongs to a valid
+	# hole punched in a write-combining memory region because you can't
+	# overlay write-combining on top of write-back and we know our base
+	# memory region is write-back, so in order for this hole to overlap
+	# our base memory region it can't be also overlapping a write-combining
+	# region.
+	printf "disable=%d\n", register[mem] > "/dev/stderr"
+	printf "disable=%d\n", register[mem] > "/proc/mtrr"
+	fflush("")
+	enabled[mem] = 0
+	for(i=0; i < cur_hole; i++) {
+		printf "disable=%d\n", register[holes[i]] > "/dev/stderr"
+		printf "disable=%d\n", register[holes[i]] > "/proc/mtrr"
+		fflush("")
+		enabled[holes[i]] = 0
+	}
+	build_entries(base[mem], base[holes[0]])
+	for(i=0; i < cur_hole - 1; i++)
+		if (base[holes[i+1]] > end[holes[i]])
+			build_entries(end[holes[i]], base[holes[i+1]])
+	if (end[mem] > end[holes[i]])
+		build_entries(end[holes[i]], end[mem])
+	# We changed up the mtrr regs, so signal to the rdma script to
+	# reload modules that need the mtrr regs to be right.
+	exit 0
+}
+
diff --git a/glue/redhat/rdma.ifdown-ib b/glue/redhat/rdma.ifdown-ib
new file mode 100644
index 0000000..1cb284d
--- /dev/null
+++ b/glue/redhat/rdma.ifdown-ib
@@ -0,0 +1,183 @@
+#!/bin/bash
+# Network Interface Configuration System
+# Copyright (c) 1996-2013 Red Hat, Inc. all rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License, version 2,
+# as published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+. /etc/init.d/functions
+
+cd /etc/sysconfig/network-scripts
+. ./network-functions
+
+[ -f ../network ] && . ../network
+
+CONFIG=${1}
+
+source_config
+
+# Allow the user to override the detection of our physical device by passing
+# it in.  No checking is done, if the user gives us a bogus dev, it's
+# their problem.
+[ -n "${PHYSDEV}" ] && REALDEVICE="$PHYSDEV"
+
+. /etc/sysconfig/network
+
+# Check to make sure the device is actually up
+check_device_down ${DEVICE} && exit 0
+
+# If we are a P_Key device, we need to munge a few things
+if [ "${PKEY}" = yes ]; then
+	[ -z "${PKEY_ID}" ] && {
+	        net_log $"InfiniBand IPoIB device: PKEY=yes requires a PKEY_ID"
+	        exit 1
+	}
+	[ -z "${PHYSDEV}" ] && {
+	        net_log $"InfiniBand IPoIB device: PKEY=yes requires a PHYSDEV"
+	        exit 1
+	}
+	# Normalize our PKEY_ID to have the high bit set
+	NEW_PKEY_ID=`printf "0x%04x" $(( 0x8000 | ${PKEY_ID} ))`
+	NEW_PKEY_NAME=`printf "%04x" ${NEW_PKEY_ID}`
+	[ "${DEVICE}" != "${PHYSDEV}.${NEW_PKEY_NAME}" ] && {
+                net_log $"Configured DEVICE name does not match what new device name would be.  This
+is most likely because once the PKEY_ID was normalized, it no longer
+resulted in the expected device naming, and so the DEVICE entry in the
+config file needs to be updated to match. This can also be caused by
+giving PKEY_ID as a hex number but without using the mandatory 0x prefix.
+	Configured DEVICE=$DEVICE
+        Configured PHYSDEV=$PHYSDEV
+        Configured PKEY_ID=$PKEY_ID
+        Calculated PKEY_ID=$NEW_PKEY_ID
+        Calculated name=${PHYSDEV}.${NEW_PKEY_NAME}"
+                exit 1
+        }
+        [ -d "/sys/class/net/${DEVICE}" ] || exit 0
+        # When we get to downing the IP address, we need REALDEVICE to
+        # point to our PKEY device
+        REALDEVICE="${DEVICE}"
+fi
+
+
+if [ "${SLAVE}" != "yes" -o -z "${MASTER}" ]; then
+if [ -n "${HWADDR}" -a -z "${MACADDR}" ]; then
+    HWADDR=$(echo $HWADDR | tail -c 24)
+    FOUNDMACADDR=$(get_hwaddr ${REALDEVICE} | tail -c 24)
+    if [ -n "${FOUNDMACADDR}" -a "${FOUNDMACADDR}" != "${HWADDR}" ]; then
+        NEWCONFIG=$(get_config_by_hwaddr ${FOUNDMACADDR})
+	if [ -n "${NEWCONFIG}" ]; then
+	   eval $(LANG=C grep -F "DEVICE=" $NEWCONFIG)
+	else
+	   net_log $"Device ${DEVICE} has MAC address ${FOUNDMACADDR}, instead of configured address ${HWADDR}. Ignoring."
+	   exit 1
+	fi
+	if [ -n "${NEWCONFIG}" -a "${NEWCONFIG##*/}" != "${CONFIG##*/}" -a "${DEVICE}" = "${REALDEVICE}" ]; then
+	   exec /sbin/ifdown ${NEWCONFIG}
+	else
+	   net_log $"Device ${DEVICE} has MAC address ${FOUNDMACADDR}, instead of configured address ${HWADDR}. Ignoring."
+	   exit 1
+	fi
+    fi
+fi
+fi
+
+if is_bonding_device ${DEVICE} ; then
+    for device in $(LANG=C grep -l "^[[:space:]]*MASTER=\"\?${DEVICE}\"\?\([[:space:]#]\|$\)" /etc/sysconfig/network-scripts/ifcfg-*) ; do
+	is_ignored_file "$device" && continue
+	/sbin/ifdown ${device##*/}
+    done
+    for arg in $BONDING_OPTS ; do
+	key=${arg%%=*};
+	[[ "${key}" != "arp_ip_target" ]] && continue
+	value=${arg##*=};
+	if [ "${value:0:1}" != "" ]; then
+            OLDIFS=$IFS;
+            IFS=',';
+            for arp_ip in $value; do
+		if grep -q $arp_ip /sys/class/net/${DEVICE}/bonding/arp_ip_target; then
+                    echo "-$arp_ip" > /sys/class/net/${DEVICE}/bonding/arp_ip_target
+		fi
+            done
+            IFS=$OLDIFS;
+	else
+	    value=${value#+};
+	    if grep -q $value /sys/class/net/${DEVICE}/bonding/arp_ip_target; then
+                echo "-$value" > /sys/class/net/${DEVICE}/bonding/arp_ip_target
+	    fi
+	fi
+    done
+fi
+
+/etc/sysconfig/network-scripts/ifdown-ipv6 ${CONFIG}
+
+retcode=0
+[ -n "$(pidof -x dhclient)" ] && {
+   for VER in "" 6 ; do
+	if [ -f "/var/run/dhclient$VER-${DEVICE}.pid" ]; then
+		dhcpid=$(cat /var/run/dhclient$VER-${DEVICE}.pid)
+		generate_lease_file_name $VER
+		if [[ "$DHCPRELEASE" = [yY1]* ]];  then
+			/sbin/dhclient -r -lf ${LEASEFILE} -pf /var/run/dhclient$VER-${DEVICE}.pid ${DEVICE} >/dev/null 2>&1
+			retcode=$?
+		else
+			kill $dhcpid >/dev/null 2>&1
+			retcode=$?
+			reason=STOP$VER interface=${DEVICE} /sbin/dhclient-script
+		fi
+		if [ -f "/var/run/dhclient$VER-${DEVICE}.pid" ]; then
+			rm -f /var/run/dhclient$VER-${DEVICE}.pid
+			kill $dhcpid >/dev/null 2>&1
+		fi
+	fi
+    done
+}
+# we can't just delete the configured address because that address
+# may have been changed in the config file since the device was
+# brought up.  Flush all addresses associated with this
+# instance instead.
+if [ -d "/sys/class/net/${REALDEVICE}" ]; then
+	if [ "${REALDEVICE}" = "${DEVICE}" ]; then
+		ip addr flush dev ${REALDEVICE} scope global 2>/dev/null
+	else
+		ip addr flush dev ${REALDEVICE} label ${DEVICE} scope global 2>/dev/null
+	fi
+
+	if [ "${SLAVE}" = "yes" -a -n "${MASTER}" ]; then
+		echo "-${DEVICE}" > /sys/class/net/${MASTER}/bonding/slaves 2>/dev/null
+	fi
+
+	if [ "${REALDEVICE}" = "${DEVICE}" ]; then
+		ip link set dev ${DEVICE} down 2>/dev/null
+	fi
+fi
+[ "$retcode" = "0" ] && retcode=$?
+
+# wait up to 5 seconds for device to actually come down...
+waited=0
+while ! check_device_down ${DEVICE} && [ "$waited" -lt 50 ] ; do
+    usleep 10000
+    waited=$(($waited+1))
+done
+
+if [ "$retcode" = 0 ] ; then
+    /etc/sysconfig/network-scripts/ifdown-post $CONFIG
+    # do NOT use $? because ifdown should return whether or not
+    # the interface went down.
+fi
+
+if [ -n "$PKEY" ]; then
+    # PKey PKEY
+    echo "$NEW_PKEY_ID" > /sys/class/net/${PHYSDEV}/delete_child
+fi
+
+exit $retcode
diff --git a/glue/redhat/rdma.ifup-ib b/glue/redhat/rdma.ifup-ib
new file mode 100644
index 0000000..bb4d4f7
--- /dev/null
+++ b/glue/redhat/rdma.ifup-ib
@@ -0,0 +1,308 @@
+#!/bin/bash
+# Network Interface Configuration System
+# Copyright (c) 1996-2013 Red Hat, Inc. all rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License, version 2,
+# as published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+. /etc/init.d/functions
+
+cd /etc/sysconfig/network-scripts
+. ./network-functions
+
+[ -f ../network ] && . ../network
+
+CONFIG="${1}"
+
+need_config "${CONFIG}"
+
+source_config
+
+# Allow the user to override the detection of our physical device by passing
+# it in.  No checking is done, if the user gives us a bogus dev, it's
+# their problem.
+[ -n "${PHYSDEV}" ] && REALDEVICE="$PHYSDEV"
+
+if [ "${BOOTPROTO}" = "dhcp" ]; then
+    DYNCONFIG=true
+fi
+
+# load the module associated with that device
+# /sbin/modprobe ${REALDEVICE}
+is_available_wait ${REALDEVICE} ${DEVTIMEOUT}
+
+# bail out, if the MAC does not fit
+if [ -n "${HWADDR}" ]; then
+	FOUNDMACADDR=$(get_hwaddr ${REALDEVICE} | tail -c 24)
+	HWADDR=$(echo $HWADDR | tail -c 24)
+	if [ "${FOUNDMACADDR}" != "${HWADDR}" ]; then
+		net_log $"Device ${DEVICE} has different MAC address than expected, ignoring."
+		exit 1
+	fi
+fi
+
+# now check the real state
+is_available ${REALDEVICE} || {
+      if [ -n "$alias" ]; then
+         net_log $"$alias device ${DEVICE} does not seem to be present, delaying initialization."
+      else
+         net_log $"Device ${DEVICE} does not seem to be present, delaying initialization."
+      fi
+      exit 1
+}
+
+# if we are a P_Key device, create the device if needed
+if [ "${PKEY}" = yes ]; then
+	[ -z "${PKEY_ID}" ] && {
+		net_log $"InfiniBand IPoIB device: PKEY=yes requires a PKEY_ID"
+		exit 1
+	}
+	[ -z "${PHYSDEV}" ] && {
+		net_log $"InfiniBand IPoIB device: PKEY=yes requires a PHYSDEV"
+		exit 1
+	}
+	# Normalize our PKEY_ID to have the high bit set
+	NEW_PKEY_ID=`printf "0x%04x" $(( 0x8000 | ${PKEY_ID} ))`
+	NEW_PKEY_NAME=`printf "%04x" ${NEW_PKEY_ID}`
+	[ "${DEVICE}" != "${PHYSDEV}.${NEW_PKEY_NAME}" ] && {
+		net_log $"Configured DEVICE name does not match what new device name would be.  This
+is most likely because once the PKEY_ID was normalized, it no longer
+resulted in the expected device naming, and so the DEVICE entry in the
+config file needs to be updated to match. This can also be caused by
+giving PKEY_ID as a hex number but without using the mandatory 0x prefix.
+	Configured DEVICE=$DEVICE
+	Configured PHYSDEV=$PHYSDEV
+	Configured PKEY_ID=$PKEY_ID
+	Calculated PKEY_ID=$NEW_PKEY_ID
+	Calculated name=${PHYSDEV}.${NEW_PKEY_NAME}"
+		exit 1
+	}
+	[ -d "/sys/class/net/${DEVICE}" ] ||
+		echo "${NEW_PKEY_ID}" > "/sys/class/net/${PHYSDEV}/create_child"
+	[ -d "/sys/class/net/${DEVICE}" ] || {
+		echo "Failed to create child device $NEW_PKEY_ID of $PHYSDEV"
+		exit 1
+	}
+	# When we get to setting up the IP address, we need REALDEVICE to
+	# point to our new PKEY device
+	REALDEVICE="${DEVICE}"
+fi
+
+
+if [ -n "${MACADDR}" ]; then
+    net_log $"IPoIB devices do not support setting the MAC address of the interface"
+    # ip link set dev ${DEVICE} address ${MACADDR}
+fi
+
+# First, do we even support setting connected mode?
+if [ -e /sys/class/net/${DEVICE}/mode ]; then
+    # OK, set the mode in all cases, that way it gets reset on a down/up
+    # cycle, allowing people to change the mode without rebooting
+    if [ "${CONNECTED_MODE}" = yes ]; then
+        echo connected > /sys/class/net/${DEVICE}/mode
+	# cap the MTU where we should based upon mode
+	[ -z "$MTU" ] && MTU=65520
+	[ "$MTU" -gt 65520 ] && MTU=65520
+    else
+        echo datagram > /sys/class/net/${DEVICE}/mode
+	# cap the MTU where we should based upon mode
+	[ -z "$MTU" ] && MTU=2044
+	[ "$MTU" -gt 2044 ] && MTU=2044
+    fi
+fi
+
+if [ -n "${MTU}" ]; then
+    ip link set dev ${DEVICE} mtu ${MTU}
+fi
+
+# slave device?
+if [ "${SLAVE}" = yes -a "${ISALIAS}" = no -a "${MASTER}" != "" ]; then
+    install_bonding_driver ${MASTER}
+    grep -wq "${DEVICE}" /sys/class/net/${MASTER}/bonding/slaves 2>/dev/null || {
+	/sbin/ip link set dev ${DEVICE} down
+	echo "+${DEVICE}" > /sys/class/net/${MASTER}/bonding/slaves 2>/dev/null
+    }
+    ethtool_set
+
+    exit 0
+fi
+
+# Bonding initialization. For DHCP, we need to enslave the devices early,
+# so it can actually get an IP.
+if [ "$ISALIAS" = no ] && is_bonding_device ${DEVICE} ; then
+    install_bonding_driver ${DEVICE}
+    /sbin/ip link set dev ${DEVICE} up
+    for device in $(LANG=C grep -l "^[[:space:]]*MASTER=\"\?${DEVICE}\"\?\([[:space:]#]\|$\)" /etc/sysconfig/network-scripts/ifcfg-*) ; do
+	    is_ignored_file "$device" && continue
+	    /sbin/ifup ${device##*/}
+    done
+
+    [ -n "${LINKDELAY}" ] && /bin/sleep ${LINKDELAY}
+
+    # add the bits to setup the needed post enslavement parameters
+    for arg in $BONDING_OPTS ; do
+        key=${arg%%=*};
+        value=${arg##*=};
+	if [ "${key}" = "primary" ]; then
+            echo $value > /sys/class/net/${DEVICE}/bonding/$key
+	fi
+    done
+fi
+
+
+if [ -n "${DYNCONFIG}" ] && [ -x /sbin/dhclient ]; then
+    if [[ "${PERSISTENT_DHCLIENT}" =  [yY1]* ]]; then
+       ONESHOT="";
+    else
+       ONESHOT="-1";
+    fi;
+    generate_config_file_name
+    generate_lease_file_name
+    DHCLIENTARGS="${DHCLIENTARGS} -H ${DHCP_HOSTNAME:-${HOSTNAME%%.*}} ${ONESHOT} -q ${DHCLIENTCONF} -lf ${LEASEFILE} -pf /var/run/dhclient-${DEVICE}.pid"
+    echo
+    echo -n $"Determining IP information for ${DEVICE}..."
+    if [[ "${PERSISTENT_DHCLIENT}" !=  [yY1]* ]] && check_link_down ${DEVICE}; then
+	echo $" failed; no link present.  Check cable?"
+	exit 1
+    fi
+
+    ethtool_set
+
+    if /sbin/dhclient ${DHCLIENTARGS} ${DEVICE} ; then
+	echo $" done."
+	dhcpipv4="good"
+    else
+	echo $" failed."
+	if [[ "${IPV4_FAILURE_FATAL}"  = [Yy1]* ]] ; then
+	    exit 1
+	fi
+	if [[ "$IPV6INIT" != [yY1]* && "$DHCPV6C" != [yY1]* ]] ; then
+	    exit 1
+	fi
+	net_log "Unable to obtain IPv4 DHCP address ${DEVICE}." warning
+    fi
+# end dynamic device configuration
+else
+    if [ -z "${IPADDR}" -a -z "${IPADDR0}" -a -z "${IPADDR1}" -a -z "${IPADDR2}" ]; then
+         # enable device without IP, useful for e.g. PPPoE
+	 ip link set dev ${REALDEVICE} up
+	 ethtool_set
+	 [ -n "${LINKDELAY}" ] && /bin/sleep ${LINKDELAY}
+    else
+
+    expand_config
+
+    [ -n "${ARP}" ] && \
+	ip link set dev ${REALDEVICE} $(toggle_value arp $ARP)
+
+    if ! ip link set dev ${REALDEVICE} up ; then
+	net_log $"Failed to bring up ${DEVICE}."
+	exit 1
+    fi
+
+    ethtool_set
+
+    [ -n "${LINKDELAY}" ] && /bin/sleep ${LINKDELAY}
+
+    if [ "${DEVICE}" = "lo" ]; then
+        SCOPE="scope host"
+    else
+        SCOPE=${SCOPE:-}
+    fi
+
+    if [ -n "$SRCADDR" ]; then
+       SRC="src $SRCADDR"
+    else
+       SRC=
+    fi
+
+    # set IP address(es)
+    for idx in {0..256} ; do
+	if [ -z "${ipaddr[$idx]}" ]; then
+	    break
+	fi
+
+	if ! LC_ALL=C ip addr ls ${REALDEVICE} | LC_ALL=C grep -q "${ipaddr[$idx]}/${prefix[$idx]}" ; then
+	    [ "${REALDEVICE}" != "lo" ] && [ "${arpcheck[$idx]}" != "no" ] && \
+	    /sbin/arping -q -c 2 -w 3 -D -I ${REALDEVICE} ${ipaddr[$idx]}
+	    if [ $? = 1 ]; then
+		net_log $"Error, some other host already uses address ${ipaddr[$idx]}."
+		exit 1
+	    fi
+
+	    if ! ip addr add ${ipaddr[$idx]}/${prefix[$idx]} \
+		brd ${broadcast[$idx]:-+} dev ${REALDEVICE} ${SCOPE} label ${DEVICE}; then
+		net_log $"Error adding address ${ipaddr[$idx]} for ${DEVICE}."
+	    fi
+	fi
+
+	if [ -n "$SRCADDR" ]; then
+           sysctl -w "net.ipv4.conf.${REALDEVICE}.arp_filter=1" >/dev/null 2>&1
+	fi
+
+	# update ARP cache of neighboring computers
+	if [ "${REALDEVICE}" != "lo" ]; then
+	    /sbin/arping -q -A -c 1 -I ${REALDEVICE} ${ipaddr[$idx]}
+	    ( sleep 2;
+	      /sbin/arping -q -U -c 1 -I ${REALDEVICE} ${ipaddr[$idx]} ) > /dev/null 2>&1 < /dev/null &
+	fi
+    done
+
+    # Set a default route.
+    if [ "${DEFROUTE}" != "no" ] && [ -z "${GATEWAYDEV}" -o "${GATEWAYDEV}" = "${REALDEVICE}" ]; then
+	# set up default gateway. replace if one already exists
+	if [ -n "${GATEWAY}" ] && [ "$(ipcalc --network ${GATEWAY} ${netmask[0]} 2>/dev/null)" = "NETWORK=${NETWORK}" ]; then
+	    ip route replace default ${METRIC:+metric $METRIC} \
+		via ${GATEWAY} ${WINDOW:+window $WINDOW} ${SRC} \
+		${GATEWAYDEV:+dev $GATEWAYDEV} ||
+			net_log $"Error adding default gateway ${GATEWAY} for ${DEVICE}."
+	elif [ "${GATEWAYDEV}" = "${DEVICE}" ]; then
+	    ip route replace default ${METRIC:+metric $METRIC} \
+		${SRC} ${WINDOW:+window $WINDOW} dev ${REALDEVICE} ||
+			net_log $"Erorr adding default gateway for ${REALDEVICE}."
+	fi
+    fi
+    fi
+fi
+
+# Add Zeroconf route.
+if [ -z "${NOZEROCONF}" -a "${ISALIAS}" = "no" -a "${REALDEVICE}" != "lo" ]; then
+    ip route add 169.254.0.0/16 dev ${REALDEVICE} metric $((1000 + $(cat /sys/class/net/${REALDEVICE}/ifindex))) scope link
+fi
+
+# Inform firewall which network zone (empty means default) this interface belongs to
+if [ -x /usr/bin/firewall-cmd -a "${REALDEVICE}" != "lo" ]; then
+    /usr/bin/firewall-cmd --zone="${ZONE}" --change-interface="${DEVICE}" > /dev/null 2>&1
+fi
+
+# IPv6 initialisation?
+/etc/sysconfig/network-scripts/ifup-ipv6 ${CONFIG}
+if [[ "${DHCPV6C}"  = [Yy1]* ]] && [ -x /sbin/dhclient ]; then
+    generate_config_file_name 6
+    generate_lease_file_name 6
+    echo
+    echo -n $"Determining IPv6 information for ${DEVICE}..."
+    if /sbin/dhclient -6 -1 ${DHCPV6C_OPTIONS} ${DHCLIENTCONF} -lf ${LEASEFILE} -pf /var/run/dhclient6-${DEVICE}.pid -H ${DHCP_HOSTNAME:-${HOSTNAME%%.*}} ${DEVICE} ; then
+        echo $" done."
+    else
+        echo $" failed."
+        if [ "${dhcpipv4}" = "good" -o -n "${IPADDR}" ]; then
+            net_log "Unable to obtain IPv6 DHCP address ${DEVICE}." warning
+        else
+            exit 1
+        fi
+    fi
+fi
+
+exec /etc/sysconfig/network-scripts/ifup-post ${CONFIG} ${2}
+
diff --git a/glue/redhat/rdma.kernel-init b/glue/redhat/rdma.kernel-init
new file mode 100644
index 0000000..6cb4732
--- /dev/null
+++ b/glue/redhat/rdma.kernel-init
@@ -0,0 +1,262 @@
+#!/bin/bash
+#
+# Bring up the kernel RDMA stack
+#
+# This is usually run automatically by systemd after a hardware activation
+# event in udev has triggered a start of the rdma.service unit
+#
+
+shopt -s nullglob
+
+CONFIG=/etc/rdma/rdma.conf
+MTRR_SCRIPT=/usr/libexec/rdma-fixup-mtrr.awk
+
+LOAD_ULP_MODULES=""
+LOAD_CORE_USER_MODULES="ib_umad ib_uverbs ib_ucm rdma_ucm"
+LOAD_CORE_CM_MODULES="iw_cm ib_cm rdma_cm"
+LOAD_CORE_MODULES="ib_core ib_mad ib_sa ib_addr"
+LOAD_TECH_PREVIEW_DRIVERS="no"
+
+if [ -f $CONFIG ]; then
+    . $CONFIG
+
+    if [ "${RDS_LOAD}" == "yes" ]; then
+        IPOIB_LOAD=yes
+    fi
+
+    if [ "${IPOIB_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="ib_ipoib"
+    fi
+
+    if [ "${RDS_LOAD}" == "yes" -a -f /lib/modules/`uname -r`/kernel/net/rds/rds.ko ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES rds"
+	if [ -f /lib/modules/`uname -r`/kernel/net/rds/rds_tcp.ko ]; then
+	    LOAD_ULP_MODULES="$LOAD_ULP_MODULES rds_tcp"
+	fi
+	if [ -f /lib/modules/`uname -r`/kernel/net/rds/rds_rdma.ko ]; then
+	    LOAD_ULP_MODULES="$LOAD_ULP_MODULES rds_rdma"
+	fi
+    fi
+
+    if [ "${SRP_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_srp"
+    fi
+
+    if [ "${SRPT_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_srpt"
+    fi
+
+    if [ "${ISER_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_iser"
+    fi
+
+    if [ "${ISERT_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES ib_isert"
+    fi
+
+    if [ "${XPRTRDMA_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES xprtrdma"
+    fi
+
+    if [ "${SVCRDMA_LOAD}" == "yes" ]; then
+	LOAD_ULP_MODULES="$LOAD_ULP_MODULES svcrdma"
+    fi
+    if [ "${TECH_PREVIEW_LOAD}" == "yes" ]; then
+        LOAD_TECH_PREVIEW_DRIVERS="$TECH_PREVIEW_LOAD"
+    fi
+else
+    LOAD_ULP_MODULES="ib_ipoib"
+fi
+
+# If module $1 is loaded return - 0 else - 1
+is_loaded()
+{
+    /sbin/lsmod | grep -w "$1" > /dev/null 2>&1
+    return $?
+}
+
+load_modules()
+{
+    local RC=0
+
+    for module in $*; do
+	if ! /sbin/modinfo $module > /dev/null 2>&1; then
+	    # do not attempt to load modules which do not exist
+	    continue
+	fi
+	if ! is_loaded $module; then
+	    /sbin/modprobe $module
+	    res=$?
+	    RC=$[ $RC + $res ]
+	    if [ $res -ne 0 ]; then
+		echo
+		echo "Failed to load module $module"
+	    fi
+	fi
+    done
+    return $RC
+}
+
+# This function is a horrible hack to work around BIOS authors that should
+# be shot.  Specifically, certain BIOSes will map the entire 4GB address
+# space as write-back cacheable when the machine has 4GB or more of RAM, and
+# then they will exclude the reserved PCI I/O addresses from that 4GB
+# cacheable mapping by making on overlapping uncacheable mapping.  However,
+# once you do that, it is then impossible to set *any* of the PCI I/O
+# address space as write-combining.  This is an absolute death-knell to
+# certain IB hardware.  So, we unroll this mapping here.  Instead of
+# punching a hole in a single 4GB mapping, we redo the base 4GB mapping as
+# a series of discreet mappings that effectively are the same as the 4GB
+# mapping minus the hole, and then we delete the uncacheable mappings that
+# are used to punch the hole.  This then leaves the PCI I/O address space
+# unregistered (which defaults it to uncacheable), but available for
+# write-combining mappings where needed.
+check_mtrr_registers()
+{
+    # If we actually change the mtrr registers, then the awk script will
+    # return true, and we need to unload the ib_ipath module if it's already
+    # loaded.  The udevtrigger in load_hardware_modules will immediately
+    # reload the ib_ipath module for us, so there shouldn't be a problem.
+    [ -f /proc/mtrr -a -f $MTRR_SCRIPT ] &&
+	awk -f $MTRR_SCRIPT /proc/mtrr 2>/dev/null &&
+	if is_loaded ib_ipath; then
+		/sbin/rmmod ib_ipath
+	fi
+}
+
+load_hardware_modules()
+{
+    local -i RC=0
+
+    [ "$FIXUP_MTRR_REGS" = "yes" ] && check_mtrr_registers
+    # We match both class NETWORK and class INFINIBAND devices since our
+    # iWARP hardware is listed under class NETWORK.  The side effect of
+    # this is that we might cause a non-iWARP network driver to be loaded.
+    udevadm trigger --subsystem-match=pci --attr-nomatch=driver --attr-match=class=0x020000 --attr-match=class=0x0c0600
+    udevadm settle
+    if [ -r /proc/device-tree ]; then
+	if [ -n "`ls /proc/device-tree | grep lhca`" ]; then
+	    if ! is_loaded ib_ehca; then
+		load_modules ib_ehca
+		RC+=$?
+	    fi
+	fi
+    fi
+    if is_loaded mlx4_core -a ! is_loaded mlx4_ib; then
+        load_modules mlx4_ib
+	RC+=$?
+    fi
+    if is_loaded mlx4_core -a ! is_loaded mlx4_en; then
+        load_modules mlx4_en
+	RC+=$?
+    fi
+    if is_loaded mlx5_core -a ! is_loaded mlx5_ib; then
+	load_modules mlx5_ib
+	RC+=$?
+    fi
+    if is_loaded cxgb3 -a ! is_loaded iw_cxgb3; then
+	load_modules iw_cxgb3
+	RC+=$?
+    fi
+    if is_loaded cxgb4 -a ! is_loaded iw_cxgb4; then
+	load_modules iw_cxgb4
+	RC+=$?
+    fi
+    if is_loaded be2net -a ! is_loaded ocrdma; then
+	load_modules ocrdma
+	RC+=$?
+    fi
+    if is_loaded enic -a ! is_loaded usnic_verbs; then
+	load_modules usnic_verbs
+	RC+=$?
+    fi
+    if [ "${LOAD_TECH_PREVIEW_DRIVERS}" == "yes" ]; then
+        if is_loaded i40e -a ! is_loaded i40iw; then
+	    load_modules i40iw
+	    RC+=$?
+        fi
+    fi
+    return $RC
+}
+
+errata_58()
+{
+    # Check AMD chipset issue Errata #58
+    if test -x /sbin/lspci && test -x /sbin/setpci; then
+	if ( /sbin/lspci -nd 1022:1100 | grep "1100" > /dev/null ) &&
+	   ( /sbin/lspci -nd 1022:7450 | grep "7450" > /dev/null ) &&
+	   ( /sbin/lspci -nd 15b3:5a46 | grep "5a46" > /dev/null ); then
+	    CURVAL=`/sbin/setpci -d 1022:1100 69`
+	    for val in $CURVAL
+	    do
+		if [ "${val}" != "c0" ]; then
+		    /sbin/setpci -d 1022:1100 69=c0
+		    if [ $? -eq 0 ]; then
+			break
+		    else
+			echo "Failed to apply AMD-8131 Errata #58 workaround"
+		    fi
+		fi
+	    done
+	fi
+    fi
+}
+
+errata_56()
+{
+    # Check AMD chipset issue Errata #56
+    if test -x /sbin/lspci && test -x /sbin/setpci; then
+	if ( /sbin/lspci -nd 1022:1100 | grep "1100" > /dev/null ) &&
+	   ( /sbin/lspci -nd 1022:7450 | grep "7450" > /dev/null ) &&
+	   ( /sbin/lspci -nd 15b3:5a46 | grep "5a46" > /dev/null ); then
+	    bus=""
+	    # Look for devices AMD-8131
+	    for dev in `/sbin/setpci -v -f -d 1022:7450 19 | cut -d':' -f1,2`
+	    do
+		bus=`/sbin/setpci -s $dev 19`
+		rev=`/sbin/setpci -s $dev 8`
+		# Look for Tavor attach to secondary bus of this devices
+		for device in `/sbin/setpci -f -s $bus: -d 15b3:5a46 19`
+		do
+		    if [ $rev -lt 13 ]; then
+			/sbin/setpci -d 15b3:5a44 72=14
+			if [ $? -eq 0 ]; then
+			    break
+			else
+			    echo
+			    echo "Failed to apply AMD-8131 Errata #56 workaround"
+			fi
+		    else
+			continue
+		    fi
+		    # If more than one device is on the bus the issue a
+		    # warning
+		    num=`/sbin/setpci -f -s $bus: 0 | wc -l |  sed 's/\ *//g'`
+		    if [ $num -gt 1 ]; then
+			echo "Warning: your current PCI-X configuration might be incorrect."
+			echo "see AMD-8131 Errata 56 for more details."
+		    fi
+		done
+	    done
+	fi
+    fi
+}
+
+
+load_hardware_modules
+RC=$[ $RC + $? ]
+load_modules $LOAD_CORE_MODULES
+RC=$[ $RC + $? ]
+load_modules $LOAD_CORE_CM_MODULES
+RC=$[ $RC + $? ]
+load_modules $LOAD_CORE_USER_MODULES
+RC=$[ $RC + $? ]
+load_modules $LOAD_ULP_MODULES
+RC=$[ $RC + $? ]
+
+errata_58
+errata_56
+
+/usr/libexec/rdma-set-sriov-vf
+
+exit $RC
diff --git a/glue/redhat/rdma.mlx4-setup.sh b/glue/redhat/rdma.mlx4-setup.sh
new file mode 100644
index 0000000..5e71ade
--- /dev/null
+++ b/glue/redhat/rdma.mlx4-setup.sh
@@ -0,0 +1,91 @@
+#!/bin/bash
+dir="/sys/bus/pci/drivers/mlx4_core"
+[ ! -d $dir ] && exit 1
+pushd $dir >/dev/null
+
+function set_dual_port() {
+	device=$1
+	port1=$2
+	port2=$3
+	pushd $device >/dev/null
+	cur_p1=`cat mlx4_port1`
+	cur_p2=`cat mlx4_port2`
+
+	# special case the "eth eth" mode as we need port2 to
+	# actually switch to eth before the driver will let us
+	# switch port1 to eth as well
+	if [ "$port1" == "eth" ]; then
+		if [ "$port2" != "eth" ]; then
+			echo "In order for port1 to be eth, port2 to must also be eth"
+			popd >/dev/null
+			return
+		fi
+		if [ "$cur_p2" != "eth" -a "$cur_p2" != "auto (eth)" ]; then
+			tries=0
+			echo "$port2" > mlx4_port2 2>/dev/null
+			sleep .25
+			cur_p2=`cat mlx4_port2`
+			while [ "$cur_p2" != "eth" -a "$cur_p2" != "auto (eth)" -a $tries -lt 10 ]; do
+				sleep .25
+				let tries++
+				cur_p2=`cat mlx4_port2`
+			done
+			if [ "$cur_p2" != "eth" -a "$cur_p2" != "auto (eth)" ]; then
+				echo "Failed to set port2 to eth mode"
+				popd >/dev/null
+				return
+			fi
+		fi
+		if [ "$cur_p1" != "eth" -a "$cur_p1" != "auto (eth)" ]; then
+			tries=0
+			echo "$port1" > mlx4_port1 2>/dev/null
+			sleep .25
+			cur_p1=`cat mlx4_port1`
+			while [ "$cur_p1" != "eth" -a "$cur_p1" != "auto (eth)" -a $tries -lt 10 ]; do
+				sleep .25
+				let tries++
+				cur_p1=`cat mlx4_port1`
+			done
+			if [ "$cur_p1" != "eth" -a "$cur_p1" != "auto (eth)" ]; then
+				echo "Failed to set port1 to eth mode"
+			fi
+		fi
+		popd >/dev/null
+		return
+	fi
+
+	# our mode is not eth <anything> as that is covered above
+	# so we should be able to succesfully set the ports in
+	# port1 then port2 order
+	if [ "$cur_p1" != "$port1" -o "$cur_p2" != "$port2" ]; then
+		# Try setting the ports in order first
+		echo "$port1" > mlx4_port1 2>/dev/null ; sleep .1
+		echo "$port2" > mlx4_port2 2>/dev/null ; sleep .1
+		cur_p1=`cat mlx4_port1`
+		cur_p2=`cat mlx4_port2`
+	fi
+
+	if [ "$cur_p1" != "$port1" -o "$cur_p2" != "$port2" ]; then
+		# Try reverse order this time
+		echo "$port2" > mlx4_port2 2>/dev/null ; sleep .1
+		echo "$port1" > mlx4_port1 2>/dev/null ; sleep .1
+		cur_p1=`cat mlx4_port1`
+		cur_p2=`cat mlx4_port2`
+	fi
+
+	if [ "$cur_p1" != "$port1" -o "$cur_p2" != "$port2" ]; then
+		echo "Error setting port type on mlx4 device $device"
+	fi
+
+	popd >/dev/null
+	return
+}
+
+
+while read device port1 port2 ; do
+	[ -d "$device" ] || continue
+	[ -z "$port1" ] && continue
+	[ -f "$device/mlx4_port2" -a -z "$port2" ] && continue
+	[ -f "$device/mlx4_port2" ] && set_dual_port $device $port1 $port2 || echo "$port1" > "$device/mlx4_port1"
+done
+popd 2&>/dev/null
diff --git a/glue/redhat/rdma.mlx4.conf b/glue/redhat/rdma.mlx4.conf
new file mode 100644
index 0000000..71207cc
--- /dev/null
+++ b/glue/redhat/rdma.mlx4.conf
@@ -0,0 +1,27 @@
+# Config file for mlx4 hardware port settings
+# This file is read when the mlx4_core module is loaded and used to
+# set the port types for any hardware found.  If a card is not listed
+# in this file, then its port types are left alone.
+#
+# Format:
+# <pci_device_of_card> <port1_type> [port2_type]
+#
+# @port1 and @port2:
+#   One of auto, ib, or eth.  No checking is performed to make sure that
+#   combinations are valid.  Invalid inputs will result in the driver
+#   not setting the port to the type requested.  port1 is required at
+#   all times, port2 is required for dual port cards.
+#
+# Example:
+# 0000:0b:00.0 eth eth
+#
+# You can find the right pci device to use for any given card by loading
+# the mlx4_core module, then going to /sys/bus/pci/drivers/mlx4_core and
+# seeing what possible PCI devices are listed there.  The possible values
+# for ports are: ib, eth, and auto.  However, not all cards support all
+# types, so if you get messages from the kernel that your selected port
+# type isn't supported, there's nothing this script can do about it.  Also,
+# some cards don't support using different types on the two ports (aka,
+# both ports must be either eth or ib).  Again, we can't set what the kernel
+# or hardware won't support.
+#
diff --git a/glue/redhat/rdma.mlx4.sys.modprobe b/glue/redhat/rdma.mlx4.sys.modprobe
new file mode 100644
index 0000000..781562c
--- /dev/null
+++ b/glue/redhat/rdma.mlx4.sys.modprobe
@@ -0,0 +1,5 @@
+# WARNING! - This file is overwritten any time the rdma rpm package is
+# updated.  Please do not make any changes to this file.  Instead, make
+# changes to the mlx4.conf file.  It's contents are preserved if they
+# have been changed from the default values.
+install mlx4_core /sbin/modprobe --ignore-install mlx4_core $CMDLINE_OPTS && (if [ -f /usr/libexec/mlx4-setup.sh -a -f /etc/rdma/mlx4.conf ]; then /usr/libexec/mlx4-setup.sh < /etc/rdma/mlx4.conf; fi; /sbin/modprobe mlx4_en; if /sbin/modinfo mlx4_ib > /dev/null 2>&1; then /sbin/modprobe mlx4_ib; fi)
diff --git a/glue/redhat/rdma.mlx4.user.modprobe b/glue/redhat/rdma.mlx4.user.modprobe
new file mode 100644
index 0000000..c8b4cce
--- /dev/null
+++ b/glue/redhat/rdma.mlx4.user.modprobe
@@ -0,0 +1,21 @@
+# This file is intended for users to select the various module options
+# they need for the mlx4 driver.  On upgrade of the rdma package,
+# any user made changes to this file are preserved.  Any changes made
+# to the libmlx4.conf file in this directory are overwritten on
+# pacakge upgrade.
+#
+# Some sample options and what they would do
+# Enable debugging output, device managed flow control, and disable SRIOV
+#options mlx4_core debug_level=1 log_num_mgm_entry_size=-1 probe_vf=0 num_vfs=0
+#
+# Enable debugging output and create SRIOV devices, but don't attach any of
+# the child devices to the host, only the parent device
+#options mlx4_core debug_level=1 probe_vf=0 num_vfs=7
+#
+# Enable debugging output, SRIOV, and attach one of the SRIOV child devices
+# in addition to the parent device to the host
+#options mlx4_core debug_level=1 probe_vf=1 num_vfs=7
+#
+# Enable per priority flow control for send and receive, setting both priority
+# 1 and 2 as no drop priorities
+#options mlx4_en pfctx=3 pfcrx=3
diff --git a/glue/redhat/rdma.modules-setup.sh b/glue/redhat/rdma.modules-setup.sh
new file mode 100644
index 0000000..19a182f
--- /dev/null
+++ b/glue/redhat/rdma.modules-setup.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+
+check() {
+	[ -n "$hostonly" -a -c /sys/class/infiniband_verbs/uverbs0 ] && return 0
+	[ -n "$hostonly" ] && return 255
+	return 0
+}
+
+depends() {
+	return 0
+}
+
+install() {
+	inst /etc/rdma/rdma.conf
+	inst /etc/rdma/mlx4.conf
+	inst /etc/rdma/sriov-vfs
+	inst /usr/libexec/rdma-init-kernel
+	inst /usr/libexec/rdma-fixup-mtrr.awk
+	inst /usr/libexec/mlx4-setup.sh
+	inst /usr/libexec/rdma-set-sriov-vf
+	inst /usr/lib/modprobe.d/libmlx4.conf
+	inst_multiple lspci setpci awk sleep
+	inst_multiple -o /etc/modprobe.d/mlx4.conf
+	inst_rules 98-rdma.rules 70-persistent-ipoib.rules
+}
+
+installkernel() {
+	hostonly='' instmods =drivers/infiniband =drivers/net/ethernet/mellanox =drivers/net/ethernet/chelsio =drivers/net/ethernet/cisco =drivers/net/ethernet/emulex =drivers/target
+	hostonly='' instmods crc-t10dif crct10dif_common
+}
diff --git a/glue/redhat/rdma.service b/glue/redhat/rdma.service
new file mode 100644
index 0000000..514ef58
--- /dev/null
+++ b/glue/redhat/rdma.service
@@ -0,0 +1,15 @@
+[Unit]
+Description=Initialize the iWARP/InfiniBand/RDMA stack in the kernel
+Documentation=file:/etc/rdma/rdma.conf
+RefuseManualStop=true
+DefaultDependencies=false
+Conflicts=emergency.target emergency.service
+Before=network.target remote-fs-pre.target
+
+[Service]
+Type=oneshot
+RemainAfterExit=yes
+ExecStart=/usr/libexec/rdma-init-kernel
+
+[Install]
+WantedBy=sysinit.target
diff --git a/glue/redhat/rdma.sriov-init b/glue/redhat/rdma.sriov-init
new file mode 100644
index 0000000..0d7cbc6
--- /dev/null
+++ b/glue/redhat/rdma.sriov-init
@@ -0,0 +1,137 @@
+#!/bin/bash
+#
+# Initialize SRIOV virtual devices
+#
+# This is usually run automatically by systemd after a hardware activation
+# event in udev has triggered a start of the rdma.service unit
+port=1
+
+function __get_parent_pci_dev()
+{
+    pushd /sys/bus/pci/devices/$pci_dev >/dev/null 2>&1
+    ppci_dev=`ls -l physfn | cut -f 2 -d '/'`
+    popd >/dev/null 2>&1
+}
+
+function __get_parent_ib_dev()
+{
+    ib_dev=`ls -l | awk '/'$ppci_dev'/ { print $9 }'`
+}
+
+function __get_parent_net_dev()
+{
+    for netdev in /sys/bus/pci/devices/$ppci_dev/net/* ; do
+	if [ "$port" -eq `cat $netdev/dev_port` ]; then
+	    netdev=`basename $netdev`
+	    break
+	fi
+    done
+}
+
+function __get_vf_num()
+{
+    pushd /sys/bus/pci/devices/$ppci_dev >/dev/null 2>&1
+    vf=`ls -l virtfn* | awk '/'$pci_dev'/ { print $9 }' | sed -e 's/virtfn//'`
+    popd >/dev/null 2>&1
+}
+
+function __en_sriov_set_vf()
+{
+    pci_dev=$1
+    shift
+    [ "$1" = "port" ] && port=$2 && shift 2
+    # We find our parent device by the netdev registered port number,
+    # however, the netdev port numbers start at 0 while the port
+    # numbers on the card start at 1, so we subtract 1 from our
+    # configured port number to get the netdev number
+    let port--
+    # Now we need to fill in the necessary information to pass to the ip
+    # command
+    __get_parent_pci_dev
+    __get_parent_net_dev
+    __get_vf_num
+    # The rest is easy.  Either the user passed valid arguments as options
+    # or they didn't
+    ip link set dev $netdev vf $vf $*
+}
+
+function __ib_sriov_set_vf()
+{
+    pci_dev=$1
+    shift
+    [ "$1" = "port" ] && port=$2 && shift 2
+    guid=""
+    __get_parent_pci_dev
+    __get_parent_ib_dev
+    [ -f $ib_dev/iov/$pci_dev/ports/$port/gid_idx/0 ] || return
+    while [ -n "$1" ]; do
+	case $1 in
+	    guid)
+		guid=$2
+		shift 2
+		;;
+	    pkey)
+		shift 1
+		break
+		;;
+	    *)
+		echo "Unknown option in $src"
+		shift
+		;;
+	esac
+    done
+    if [ -n "$guid" ]; then
+	guid_idx=`cat "$ib_dev/iov/$pci_dev/ports/$port/gid_idx/0"`
+	echo "$guid" > "$ib_dev/iov/ports/$port/admin_guids/$guid_idx"
+    fi
+    i=0
+    while [ -n "$1" ]; do
+	for pkey in $ib_dev/iov/ports/$port/pkeys/*; do
+	    if [ `cat $pkey` = "$1" ]; then
+		echo `basename $pkey` > $ib_dev/iov/$pci_dev/ports/$port/pkey_idx/$i
+		let i++
+		break
+	    fi
+	done
+	shift
+    done
+}
+
+[ -d /sys/class/infiniband ] || return
+pushd /sys/class/infiniband >/dev/null 2>&1
+
+if [ -z "$*" ]; then
+    src=/etc/rdma/sriov-vfs
+    [ -f "$src" ] || return
+    grep -v "^#" $src | while read -a args; do
+	# When we use read -a to read into an array, the index starts at
+	# 0, unlike below where the arg count starts at 1
+	port=1
+	next_arg=1
+        [ "${args[$next_arg]}" = "port" ] && next_arg=3
+	case ${args[$next_arg]} in
+	    guid|pkey)
+		__ib_sriov_set_vf ${args[*]}
+		;;
+	    mac|vlan|rate|spoofchk|enable)
+		__en_sriov_set_vf ${args[*]}
+		;;
+	    *)
+		;;
+	esac
+    done
+else
+    [ "$2" = "port" ] && next_arg=$4 || next_arg=$2
+    case $next_arg in
+	guid|pkey)
+	    __ib_sriov_set_vf $*
+	    ;;
+	mac|vlan|rate|spoofchk|enable)
+	    __en_sriov_set_vf $*
+	    ;;
+	*)
+	    ;;
+    esac
+fi
+
+popd >/dev/null 2>&1
diff --git a/glue/redhat/rdma.sriov-vfs b/glue/redhat/rdma.sriov-vfs
new file mode 100644
index 0000000..ef3e6c0
--- /dev/null
+++ b/glue/redhat/rdma.sriov-vfs
@@ -0,0 +1,41 @@
+# All lines in this file that start with a # are comments,
+# all other lines will be processed without argument checks
+# Format of this file is one sriov vf setting per line with
+# arguments as follows:
+#    vf [port #] [ethernet settings | infiniband settings]
+#
+#  @vf - PCI address of device to configure as found in
+#	  /sys/bus/pci/devices/
+#
+#  [port @port] - Optional: the port number we are setting on
+#         the device.  We always assume port 1 unless told
+#         otherwise.
+#
+#  Ethernet settings:
+#  mac <mac address> [additional options]
+#    @mac - mac address to assign to vf...this is currently required by
+#        the ip program if you wish to be able to set any of the other
+#        settings.  If you don't set anything on a vf, it will get a
+#        random mac address and you may use static IP addressing to
+#        have a consistent IP address in spite of the random mac
+#    @* - additional arguments are passed to ip link without any
+#      further processing/checking, additional options that could
+#      be passed as of the time of writing this are:
+#        [ vlan VLANID [ qos VLAN-QOS ] ]
+#        [ rate TXRATE ]
+#        [ spoofchk { on | off} ]
+#        [ state { auto | enable | disable} ]
+#
+#  InfiniBand settings:
+#  [guid <guid>] [pkey <space separated list of pkeys>]
+#    @guid - 64bit GUID value to assign to vf.  Omit this option to
+#          use a subnet manager assigned GUID.
+#    @pkey - one or more pkeys to assign to this guest, must be last
+#          item on line
+#
+#  Examples:
+#
+#    0000:44:00.1 guid 05011403007bcba1 pkey 0xffff 0x8002
+#    0000:44:00.1 port 2 mac aa:bb:cc:dd:ee:f0 spoofchk on
+#    0000:44:00.2 port 1 pkey 0x7fff 0x0002
+#    0000:44:00.2 port 2 mac aa:bb:cc:dd:ee:f1 vlan 10 spoofchk on state enable
diff --git a/glue/redhat/rdma.udev-ipoib-naming.rules b/glue/redhat/rdma.udev-ipoib-naming.rules
new file mode 100644
index 0000000..1002470
--- /dev/null
+++ b/glue/redhat/rdma.udev-ipoib-naming.rules
@@ -0,0 +1,13 @@
+# This is a sample udev rules file that demonstrates how to get udev to
+# set the name of IPoIB interfaces to whatever you wish.  There is a
+# 16 character limit on network device names though, so don't go too nuts
+#
+# Important items to note: ATTR{type}=="32" is IPoIB interfaces, and the
+# ATTR{address} match must start with ?* and only reference the last 8
+# bytes of the address or else the address might not match on any given
+# start of the IPoIB stack
+#
+# Note: as of rhel7, udev is case sensitive on the address field match
+# and all addresses need to be in lower case.
+#
+# ACTION=="add", SUBSYSTEM=="net", DRIVERS=="?*", ATTR{type}=="32", ATTR{address}=="?*00:02:c9:03:00:31:78:f2", NAME="mlx4_ib3"
diff --git a/glue/redhat/rdma.udev-rules b/glue/redhat/rdma.udev-rules
new file mode 100644
index 0000000..0c7a8fc
--- /dev/null
+++ b/glue/redhat/rdma.udev-rules
@@ -0,0 +1,18 @@
+# We list all the various kernel modules that drive hardware in the
+# InfiniBand stack (and a few in the network stack that might not actually
+# be RDMA capable, but we don't know that at this time and it's safe to
+# enable the IB stack, so do so unilaterally) and on load of any of that
+# hardware, we trigger the rdma.service load in systemd
+
+SUBSYSTEM=="module", KERNEL=="cxgb*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="ib_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="mlx*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="iw_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="be2net", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+SUBSYSTEM=="module", KERNEL=="enic", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
+
+# When we detect a new verbs device is added to the system, set the node
+# description on that device
+# If rdma-ndd is installed, defer the setting of the node description to it.
+SUBSYSTEM=="infiniband", KERNEL=="*", ACTION=="add", TEST!="/usr/sbin/rdma-ndd", RUN+="/bin/bash -c 'sleep 1; echo -n `hostname -s` %k > /sys/class/infiniband/%k/node_desc'"
+
diff --git a/glue/redhat/srp_daemon.service b/glue/redhat/srp_daemon.service
new file mode 100644
index 0000000..f9c4b1e
--- /dev/null
+++ b/glue/redhat/srp_daemon.service
@@ -0,0 +1,17 @@
+[Unit]
+Description=Start or stop the daemon that attaches to SRP devices
+Documentation=file:///etc/rdma/rdma.conf file:///etc/srp_daemon.conf
+DefaultDependencies=false
+Conflicts=emergency.target emergency.service
+Requires=rdma.service
+Wants=opensm.service
+After=rdma.service opensm.service
+After=network.target
+Before=remote-fs-pre.target
+
+[Service]
+Type=simple
+ExecStart=/usr/sbin/srp_daemon.sh
+
+[Install]
+WantedBy=remote-fs-pre.target
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
