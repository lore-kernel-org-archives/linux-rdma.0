From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch opensm] Allow for easily configuring multiple fabrics on one
 opensm server
Date: Wed, 29 Feb 2012 00:01:16 -0500
Message-ID: <4F4DB11C.5080203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60D3BCAAE9FE0E23113E6BCE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60D3BCAAE9FE0E23113E6BCE
Content-Type: multipart/mixed;
 boundary="------------000602060807050704010703"

This is a multi-part message in MIME format.
--------------000602060807050704010703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

There are two things that stand in the way of opensm being run on
redundant fabrics easily:

1) The opensm init script only starts one instance of opensm and opensm
will only work on one fabric per instance
2) Even if you start multiple instances, you have to hand modify config
files for each instance and then when you upgrade the opensm rpm you
either loose your modifications or loose getting new default settings

I worked around both of these issues, I've attached the files I used to
do so.

First, I have an opensm init script that allows starting multiple opensm
instances.  It supports configuring this in one of two ways:

1) Create multiple opensm.conf files, each with a numbered suffix (so
opensm.conf.1, opensm.conf.2, etc.) and it will start one opensm
instance per config file.  This allows an admin to copy the default
config over and edit the things they need, and on rpm upgrade there will
be a new default opensm.conf file so they can diff between their edited
version and the new default and see if there are changes they need to
bring back in.  This also allows for complete flexibility in setting up
the different fabrics, for instance you could use one type of routing on
one and a totally different type on the others.

2) Edit the file /etc/sysconfig/opensm and define more than one GUID in
the GUIDs variable.  This will cause the opensm init script to
automatically start one instance per GUID, passing the GUID in on the
command line.

For the most part, this works well.  However, openmpi in particular
doesn't like you to have physically separate fabrics that have the same
subnet_prefix, and you can't specify a subnet_prefix on the command line
to go along with the GUIDs.  So I wrote a patch for that and made the
init script unilaterally increment the subnet prefix for each different
GUID it's attaching to.

All in all, we use the attached opensm file in /etc/sysconfig as the
standard place you put options belonging to an init script, we have the
opensm init script, the subnet_prefix patch I wrote, and with those
combined things work quite well.

However, I will note that our init script does not (and will not ever)
play the passwordless root ssh stuff that upstream does.  This is
considered a serious security risk on side.  The idea that a customer
(let's say a wall street bank) should set up passwordless root ssh on
their cluster that's a backend to their web farm?  Oh hell no...

I might recommend that it is long since past time for that particular
misfeature of the upstream opensm init script to be done away with.
Personally, I would simply recommend that on failover from a primary to
a backup that it simply scan the fabric and build a "current guid2lid"
map from what it finds, then start updating from there.  Or something
like that.  But passwordless ssh...bleh.

Oh, and while I've got your ear...is there a good reason the opensm libs
have been soname bumping so frequently?  Is it not possible to extend
the APIs without soname bumps quite so often?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford


--------------000602060807050704010703
Content-Type: text/plain;
 name="opensm.initd"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="opensm.initd"

#!/bin/bash
#
# Bring up/down opensm
#
# chkconfig: - 15 85
# description: Activates/Deactivates InfiniBand Subnet Manager
# config: /etc/ofed/opensm.conf
#
### BEGIN INIT INFO
# Provides:       opensm
# Default-Stop: 0 1 2 3 4 5 6
# Required-Start: rdma
# Required-Stop: rdma
# Short-Description: Starts/Stops the InfiniBand Subnet Manager
# Description: Starts/Stops the InfiniBand Subnet Manager
### END INIT INFO

=2E /etc/rc.d/init.d/functions

prog=3D/usr/sbin/opensm
PID_FILE=3D/var/run/opensm.pid
[ -f /etc/sysconfig/opensm ] && . /etc/sysconfig/opensm

[ -n "$PRIORITY" ] && prio=3D"-p $PRIORITY"

ACTION=3D$1

start()
{
    local OSM_PID=3D
    if [ -z "$GUIDS" ]; then
        CONFIGS=3D""
        CONFIG_CNT=3D0
        for conf in /etc/rdma/opensm.conf.[0-9]*; do
            CONFIGS=3D"$CONFIGS $conf"
            let CONFIG_CNT++
        done
    else
        GUID_CNT=3D0
        for guid in $GUIDS; do
            let GUID_CNT++
        done
    fi
    [ -f /var/lock/subsys/opensm ] && return 0
    # Start opensm
    echo -n "Starting IB Subnet Manager: "
    [ -n "$PRIORITY" ] && echo -n "Priority=3D$PRIORITY "
    [ -n "$GUIDS" ] && echo -n "$GUID_CNT guids "
    [ -n "$CONFIGS" ] && echo -n "$CONFIG_CNT instances "
    if [ -n "$GUIDS" ]; then
	SUBNET_COUNT=3D0
        for guid in $GUIDS; do
	    SUBNET_PREFIX=3D`printf "0xfe800000000000%02d" $SUBNET_COUNT`
            $prog -B $prio -g $guid --subnet_prefix $SUBNET_PREFIX >/dev/=
null 2>&1
	    let SUBNET_COUNT++
        done
    elif [ -n "$CONFIGS" ]; then
        for config in $CONFIGS; do
            $prog -B $prio -F $config >/dev/null 2>&1
        done
    else
        $prog -B $prio >/dev/null 2>&1
    fi
    sleep 1
    OSM_PID=3D`pidof $prog`
    checkpid $OSM_PID
    RC=3D$?
    [ $RC -eq 0 ] && echo_success || echo_failure
    [ $RC -eq 0 ] && touch /var/lock/subsys/opensm
    [ $RC -eq 0 ] && echo $OSM_PID > $PID_FILE
    echo
    return $RC   =20
}

stop()
{
    [ -f /var/lock/subsys/opensm ] || return 0

    echo -n "Stopping IB Subnet Manager(s)."

    OSM_PID=3D`cat $PID_FILE`

    checkpid $OSM_PID
    RC=3D$?
    if [ $RC -ne 0 ]; then
	rm -f $PID_FILE
	rm -f /var/lock/subsys/opensm
	echo_success
	return 0
    fi
    # Kill opensm
    kill -15 $OSM_PID >/dev/null 2>&1
    cnt=3D0
    while [ $cnt -lt 6 ]; do
        checkpid $OSM_PID
	if [ $? -ne 0 ]; then
	    break
	fi
        echo -n "."
	sleep 1
	let cnt++
    done

    checkpid $OSM_PID
    if [ $? -eq 0 ]; then
	kill -KILL $OSM_PID > /dev/null 2>&1
	echo -n "+"
        sleep 1
    fi
    checkpid $OSM_PID
    DEAD=3D$?
    if [ $DEAD -eq 0 ]; then
	echo_failure
	echo
	return 1
    fi
    echo_success=20
    echo
=20
    # Remove pid file if any.
    rm -f $PID_FILE
    rm -f /var/lock/subsys/opensm
    return 0   =20
}

restart ()
{
	stop
	start
}

condrestart ()
{
	[ -f /var/lock/subsys/opensm ] && restart || return 0
}

reload ()
{
	[ -f $PID_FILE ] || return 0
	OSM_PID=3D`cat $PID_FILE`
	action $"Rescanning IB Subnet:" kill -HUP $OSM_PID
	return $?
}

usage ()
{
	echo
	echo "Usage: `basename $0` {start|stop|restart|condrestart|try-restart|f=
orce-reload|status}"
	echo
	return 2
}

case $ACTION in
	start|stop|restart|reload|condrestart|try-restart|force-reload)
	    [ `id -u` !=3D "0" ] && exit 4 ;;
esac

case $ACTION in
	start) start; RC=3D$? ;;
	stop) stop; RC=3D$? ;;
	restart) restart; RC=3D$? ;;
	reload) reload; RC=3D$? ;;
	condrestart) condrestart; RC=3D$? ;;
	try-restart) condrestart; RC=3D$? ;;
	force-reload) condrestart; RC=3D$? ;;
	status) status $prog; RC=3D$? ;;
	*) usage; RC=3D$? ;;
esac

exit $RC

--------------000602060807050704010703
Content-Type: text/plain;
 name="opensm.sysconfig"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="opensm.sysconfig"

# Problem #1: Multiple IB fabrics needing a subnet manager
#
# In the event that a machine has more than one IB subnet attached,
# and that machine is an opensm server, by default, opensm will
# only attach to one port and will not manage the fabric on the
# other port.  There are two ways to solve this problem:
#
# 1) Start opensm on multiple machines and configure it to manage
#    different fabrics on each machine
# 2) Configure opensm to start multiple instances on a single
#    machine
#
# Both solutions to this problem require non-standard configurations.
# In other words, you would normally have to modify /etc/rdma/opensm.conf=

# and once you do that, the file will no longer be updated for new
# options when opensm is upgraded.  In an effort to allow people to
# have more than one subnet managed by opensm without having to modify
# the system default opensm.conf file, we have enabled two methods
# for modifying the default opensm config items needed to enable
# multiple fabric management.
#
# Method #1: Create multiple opensm.conf files in non-standard locations
#   Copy /etc/rdma/opensm.conf to /etc/rdma/opensm.conf.<number>
#     (do this once for each instance you want started)
#   Edit each copy of the opensm.conf file to reflect the necessary chang=
es
#     for a multiple instance startup.  If you need to manage more than
#     one fabric, you will have to change the guid option in each file
#     to specify the guid of the specific port you want opensm attached
#     to.
#
# The advantage to method #1 is that, on the off chance you want to do
# really special custom things on different ports, like have different
# QoS settings depending on which port you are attached to, you have the
# freedom to edit any and all settings for each instance without those
# changes affecting other instances or being lost when opensm upgrades.
#
# Method #2: Specify multiple GUIDS variable entries in this file
#   Uncomment the below GUIDS variable and enter each guid you need to at=
tach
#     to into the list.  If using this method you need to enter each
#     guid into the list as we won't attach to any default ports, only
#     those specified in the list.
#
#GUIDS=3D"0x0002c90300048ca1 0x0002c90300048ca2"
#
# The obvious advantage to method #2 is that it's simple and doesn't
# clutter up your file system, but it is far more limited in what you
# can do.  If you enable method #2, then even if you create the files
# referenced in method #1, they will be ignored.
#
# Problem #2: Activating a backup subnet manager
#
# The default priority of opensm is set so that it wants to be the
# primary subnet manager.  This is great when you are only running
# opensm on one server, but if you want to have a non-primary opensm
# instance for failover, then you have to manually edit the opensm.conf
# file like for problem #1.  This carries with it all the problems
# listed above.  If you wish to enable opensm as a non-primary manager,
# then you can uncomment the PRIORITY variable below and set it to
# some number between 0 and 15, where 15 is the highest priority and
# the primary manager, with 0 being the lowest backup server.  This metho=
d
# will work with the GUIDS option above, and also with the multiple
# config files in method #1 above.  However, only a single priority is
# supported here.  If you wanted more than one priority (say this machine=

# is the primary on the first fabric, and second on the second fabric,
# while the other opensm server is primary on the second fabric and
# second on the primary), then the only way to do that is to use method #=
1
# above and individually edit the config files.  If you edit the config
# files to set the priority and then also set the priority here, then
# this setting will override the config files and render that particular
# edit useless.
#
#PRIORITY=3D15

--------------000602060807050704010703
Content-Type: text/x-patch;
 name="opensm-3.3.13-prefix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="opensm-3.3.13-prefix.patch"

diff -up opensm-3.3.13/man/opensm.8.in.prefix opensm-3.3.13/man/opensm.8.=
in
--- opensm-3.3.13/man/opensm.8.in.prefix	2012-02-28 18:27:33.297714661 -0=
500
+++ opensm-3.3.13/man/opensm.8.in	2012-02-28 18:31:00.957696942 -0500
@@ -11,6 +11,7 @@ opensm \- InfiniBand subnet manager and=20
 [\-g(uid) <GUID in hex>]
 [\-l(mc) <LMC>]
 [\-p(riority) <PRIORITY>]
+[\-\-subnet_prefix <PREFIX in hex>]
 [\-smkey <SM_Key>]
 [\-\-sm_sl <SL number>]
 [\-r(eassign_lids)]
@@ -130,6 +131,13 @@ This will effect the handover cases, whe
 is chosen by priority and GUID.  Range goes from 0
 (default and lowest priority) to 15 (highest).
 .TP
+\fB\-\-subnet_prefix\fR <PREFIX in hex>
+This option specifies the subnet prefix to use in
+on the fabric.  The default prefix is
+0xfe80000000000000.  OpenMPI in particular requires
+separate fabrics plugged into different ports to
+have different prefixes or else it won't run.
+.TP
 \fB\-smkey\fR <SM_Key value>
 This option specifies the SM\'s SM_Key (64 bits).
 This will effect SM authentication.
diff -up opensm-3.3.13/opensm/main.c.prefix opensm-3.3.13/opensm/main.c
--- opensm-3.3.13/opensm/main.c.prefix	2012-01-17 08:22:40.000000000 -050=
0
+++ opensm-3.3.13/opensm/main.c	2012-02-28 18:31:34.224694111 -0500
@@ -156,6 +156,9 @@ static void show_usage(void)
 	       "          This will effect the handover cases, where master\n"
 	       "          is chosen by priority and GUID.  Range goes\n"
 	       "          from 0 (lowest priority) to 15 (highest).\n\n");
+	printf("--subnet_prefix <prefix>\n"
+	       "          Set the subnet prefix to something other than the\n"
+	       "          default value of 0xfe80000000000000\n\n");
 	printf("--smkey, -k <SM_Key>\n"
 	       "          This option specifies the SM's SM_Key (64 bits).\n"
 	       "          This will effect SM authentication.\n"
@@ -607,6 +610,7 @@ int main(int argc, char *argv[])
 		{"once", 0, NULL, 'o'},
 		{"reassign_lids", 0, NULL, 'r'},
 		{"priority", 1, NULL, 'p'},
+		{"subnet_prefix", 1, NULL, 13},
 		{"smkey", 1, NULL, 'k'},
 		{"routing_engine", 1, NULL, 'R'},
 		{"ucast_cache", 0, NULL, 'A'},
@@ -911,6 +915,11 @@ int main(int argc, char *argv[])
 			printf(" Priority =3D %d\n", temp);
 			break;
=20
+		case 13:
+			opt.subnet_prefix =3D cl_hton64(strtoull(optarg, NULL, 16));
+			printf(" Subnet_Prefix =3D <0x%" PRIx64 ">\n", cl_hton64(opt.subnet_p=
refix));
+			break;
+
 		case 'k':
 			sm_key =3D cl_hton64(strtoull(optarg, NULL, 16));
 			printf(" SM Key <0x%" PRIx64 ">\n", cl_hton64(sm_key));

--------------000602060807050704010703--

--------------enig60D3BCAAE9FE0E23113E6BCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPTbEcAAoJELgmozMOVy/d+d0P/jrfXdYBM0FxozGimweA61fz
p0p1ZwxJXpcJpQGYL74y1NmvScP6nkfTwU4QKazCtOFxu7FVluYJ2TDrQ4Y3ibuY
aTewvDESehBE4AOIx458XQ6TECIsc9Hf50tGrSU/QLGw5jvlo9k8jzxZi9lsEjqj
RgJU0zvQKvegUdlg9bwOprfVCRJZlm2kDDWlweK4EDQGhlQDz4IDhOZNejhSeCV6
bR54WtcWC75qAMncNIlXClkQ7mLOaf0VjpOaSRpxALIfQGeqs0CQfxNbiMwVqjSj
wfaIyiJIREyi7nKgp6HQwMqwMT5HbYdIca8L4vZQGKgkRaYTAdJ1Hnws6xHOQB8v
M1TeH9zjAVh/cgutFaAzKN9Zyfk7+isqGOzxgbsSZlXdvVWjRe4dm865vP4Muyh/
3d8sD6/aeHmpP/moLOcKzeNYOPqtKQXpwTIrfwavgdg9SdCJimC1V8fvvzz3xg4P
dbCf6v224hQgLdqS8g0Z7xyJ6ObC5xCHhKLdua0fMiCZCKxg8sQfvkyYtoT+gpQt
rkGYgfv0i70ftbfPxYPd3MFjUS6bwTt/7lEwZyfXPX2hwOl4JM1qQY8/gbkOCh/2
zPMDg60mhywH0LDmJQLj6phumxDZPCDptDN/am9mji7Gy1CmwOEJ7rKBmp7IG6DZ
L5Owr9XchVatP4kjTv9Q
=E3eb
-----END PGP SIGNATURE-----

--------------enig60D3BCAAE9FE0E23113E6BCE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
