From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Obtaining initiator hex address for srpt acls, not
 /sys/class/infiniband/mlx4_0/ports/1/gids/0
Date: Tue, 19 Jan 2016 14:46:46 -0500
Message-ID: <569E92A6.7070704@redhat.com>
References: <CA+X5Wn5xE7Xig42HtJ+dCyxFWVhqfbEisaD-Md6FCmYJG5+wuQ@mail.gmail.com>
 <CA+X5Wn70Sq-CipTLJJVPmrhMTS-t65v0Q4ejS3ppWZW4nkEwQw@mail.gmail.com>
 <CA+X5Wn7zEdXy4-3rhTqU+NJzD1LRHA+w651yx4tsEvToiHu+Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nrEIIN08RGNsX4lNq0XIIa8mKjt3HB0Fl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn7zEdXy4-3rhTqU+NJzD1LRHA+w651yx4tsEvToiHu+Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nrEIIN08RGNsX4lNq0XIIa8mKjt3HB0Fl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/06/2016 04:05 AM, james harvey wrote:
> After more digging, I found out this out of no where hex string is
> referred to as "initiator_ext", and is being sent since srp_daemon.sh
> give srp_daemon the "-n" flag.  Since there's no user-set
> initiator_ext, srp_daemon grabs it from somewhere.
>=20
> If I want to continue using the "-n" flag, how can I find out what my
> initiator is going to send as initiator_ext, so the target can be set
> up to work with it?
>=20
> Or, can I set my own initiator_ext, it looks by appending it to
> /etc/srp_daemon.conf ?
>=20
> Why doesn't ibsrpdm give the initiator_ext value?

As I recall, the value you will get here varies based upon the
hardware/driver in use.  On some cards, you get the local GID reversed,
on other cards you get something else.  What I ended up doing when
setting up the ACLs for srp was to do this:

# ssh to srp target to add an ACL for this client
# targetcli uses srp names of the format:
# "ib.<32 hex chars>"
# for both target wwn and client wwn.
__setup_srp_client_path() {
        local server=3D"$1"
        local fabric=3D"$2"
        local path_num=3D"$3"
        local dgid=3D${SRP_DGID[$server-$fabric]}
        local var_file=3D/etc/rdma/srp_client_variables
        local tmp_conf=3D/etc/rdma/srp_client_tmp_conf
        local conf_file=3D/etc/srp_daemon.conf
        echo -e "a pkey=3Dffff,dgid=3D$dgid\nd\n" > $tmp_conf
        pushd /dev/infiniband
        for umad in umad*; do
                srp_daemon -n -c -o -f $tmp_conf -d ./$umad | sed -e
'y/,/\n/' > $var_file
                [ -s $var_file ] && break
        done
        local ibdev=3D`cat /sys/class/infiniband_mad/$umad/ibdev`
        local ibport=3D`cat /sys/class/infiniband_mad/$umad/port`
        rm $tmp_conf
        popd
        [ ! -s $var_file ] && return
        port_guid=3D`ibstat $ibdev $ibport | grep "Port GUID" | cut -f 2
-d 'x'`
        init_ext=3D`grep initiator_ext $var_file | cut -f 2 -d '=3D'`
        sgid=3D"${init_ext}${port_guid}"
        # assuming targetcli global pref auto_add_mapped_luns=3Dtrue (the=

default)
        # just creating the acl should map existing target luns to this
client.
        # We have auto mapped luns turned off, so we also map our
specific lun
        # to our ACL
        ssh $server "targetcli /srpt/ib.$dgid/acls create ib.$sgid;
targetcli /srpt/ib.$dgid/acls/ib.$sgid create 0
/backstores/block/srp-$host_part; targetcli saveconfig"
        sed -e "/.*dgid=3D$dgid.*/ d" -i $conf_file
        echo "a pkey=3Dffff,dgid=3D$dgid,queue_size=3D128,max_cmd_per_lun=
=3D128"
>> $conf_file
        rm $var_file
        if [ $path_num -eq 0 ]; then
                mkdir -p /srv/$server/SRP
        fi
}

# Call this to set up possible SRP device definitions.
# @1 - Server name to create logins too
# @2+ - List of fabrics to access devices via, or empty for all possible
#
# If there is more than one path to the device, we automatically use
# lvm multipath to access the device.
#
# Once paths/logins are established, create a mount point on the system,
# add the device to the fstab, create an fs on the device, but don't
# mount the device
Setup_Srp_Client_Mounts() {
        if [ -z "$1" ]; then
                echo "Usage: "
                echo -e "\tSetup_Srp_Client_Mounts <server> [fabrics ...]=
"
                echo -e "\t\tserver - Required, we will ssh to this
server to"
                echo -e "\t\t  add ourselves to the ACLs and map our LUN"=

                echo -e "\t\tfabric - One or more fabrics you wish to
enable"
                echo -e "\t\t  access to the LUN via.  The fabrics will b=
e"
                echo -e "\t\t  checked to make sure that both the server
and"
                echo -e "\t\t  this host have connections to the
fabrics.  If"
                echo -e "\t\t  empty, then the union of all fabrics for t=
he"
                echo -e "\t\t  server and this host will be used.  If the=
re"
                echo -e "\t\t  is more than one fabric configured,
multipath"
                echo -e "\t\t  will be enabled by default."
                return
        fi
        local server=3D"$1"
        local paths=3D""
        local num_paths=3D0
        shift 1
        __if_x_in_y "$server" "$SRP_SERVERS" || return
        # Turn off the disallow all option in the config file while we do=

        # our work, we restore this at the end
        Enable_Service srpd
        sed -e '/^d$/ d' -i /etc/srp_daemon.conf
        [ -n "$1" ] && paths=3D"$*" || paths=3D"${SRP_FABRICS[$server]}"
        for fabric in $paths; do
                __if_x_in_y "$fabric" "$HOST_FABRICS" || continue
                __if_x_in_y "$fabric" "${SRP_FABRICS[$server]}" || contin=
ue
                __setup_srp_client_path "$server" "$fabric" $num_paths
                let num_paths++
        done
        if [ $num_paths -gt 1 ]; then
                if [ ! -f /etc/multipath.conf ]; then
                        cp
/usr/share/doc/device-mapper-multipath-*/multipath.conf /etc
                fi
                Enable_Service multipathd
                Start_Service multipathd
        fi
        echo "d" >> /etc/srp_daemon.conf
        Start_Service srpd
        echo "Your SRP client mounts from $server have been added to the"=

        echo "system.  If you enabled more than one path to the device,"
        echo "please find your new multipath device, otherwise find the
newly"
        echo "added SCSI device, then perform the following actions:"
        echo "  1) Make sure no partitions got automounted due to existin=
g"
        echo "     data once you added the device"
        echo "  2) Create or select a partition to use"
        echo "  3) Create a filesystem on the partition (if needed)"
        echo "  4) Run blkid on the partition to get the fs UUID"
        echo "  5) Add the line UUID=3D\"uuid\" /srv/<server>/SRP ... to =
the"
        echo "     fstab so the device is automounted on reboots"
        echo "     eg:"
        echo "          UUID=3D\"c37e3e64-25bb-44e5-96d2-937800e0e3e3\"
/srv/rdma-storage-01/SRP        xfs     defaults,_netdev        1 2"
}


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nrEIIN08RGNsX4lNq0XIIa8mKjt3HB0Fl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnpKmAAoJELgmozMOVy/d3pgQAJtrSlMZ3SZ7w74HbBXej/Io
hu6IQ1wGdCBGd54mHMtzVQARPJW0jnYMyTYNWKLxKTbUVZiivxvc7B6sykJMnAob
6CFq0QYRXYOwQ5Z48VTYqt/E7nR74ikcTWbyBQ842YH7PHmuOvyGFQhflylnAWOI
ityJEZaxW9n3J1ouaKm/he1XOgx0N+xshMY+TTM26bqfKQd95deLYwdUiMUh7oOU
W8mkfJu785DXxteVwgGAkuvZyOcS8T0B7mhGc13qzxRrybw5n+j8MePxQdANYj4G
RH8bDB5rvkewyTyJ2GI+kCymPRh6fmgD1mqNYYJREamIvRidpP+B9daxTNPQ4q5W
u8J5UOo4085VrkoXpqxCmV+VkJ2SXa8oneZ1B41hTVmXaGBnIXeEGnLfW3XVm+Ym
DM83oK5CcnPk0pgKvunL6PPeOeoMFT/JXyivzFLlXD0BMq72WVDCbUe+tKNdzVtF
8MnBka3SPcF21OQpszOleaGX1GUtFe5Xd1yCBgkJJ5El18AdhFh3JcBYdQIzOUjh
fM9YvM34aq1Irx5c7E4HjI6fFiKo5k0pIRiQwmtIHiDpApSuMw92pr9QeVu3CVQ9
/7+t2tJrm4GYtcMwQeZ5dB/hAcmuKT99h6UK8nWAtXIXUpw/V/sk7iPXv2q2bOn7
uSOqKtyoOGksn/+aMOAn
=x4rO
-----END PGP SIGNATURE-----

--nrEIIN08RGNsX4lNq0XIIa8mKjt3HB0Fl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
