From: Ken Teague <kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: Re: opensm with multiple IB subnets
Date: Thu, 22 Apr 2010 12:47:09 -0700
Message-ID: <i2v2d0a59b21004221247u56927b57m2fc033079e42ed73@mail.gmail.com>
References: <k2s2d0a59b21004201413ia115ae29u661f8df428d5ad08@mail.gmail.com>
	 <u2q2d0a59b21004201707gecf7f978pa585ada342ccb9b6@mail.gmail.com>
	 <4BCF1215.7070601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BCF1215.7070601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thank you, Yevgeny.  I've modified my init script accordingly and
restarted opensm.  For anyone else that may find it useful, here is
the "start" portion of my init script:

start () {
    echo -n "Starting opensm: "
    for GUID in `${IBSTAT_BIN} ${IBSTAT_ARG}`
    do
        export OSM_TMP_DIR=3D"/tmp/opensm/${GUID}"
        export OSM_CACHE_DIR=3D"/var/cache/opensm/${GUID}"
        export OSM_LOG_DIR=3D"/var/log/opensm/${GUID}"
        [ -d ${OSM_TMP_DIR} ] || mkdir -p ${OSM_TMP_DIR}
        [ -d ${OSM_CACHE_DIR} ] || mkdir -p ${OSM_CACHE_DIR}
        [ -d ${OSM_LOG_DIR} ] || mkdir ${OSM_LOG_DIR}
        ${OPENSM_BIN} --log_file ${OSM_LOG_DIR}/opensm.log
${OPENSM_ARG} ${GUID} > /dev/null
    done
    if [[ $RETVAL -eq 0 ]]; then
        touch /var/lock/subsys/opensm
        success
    else
        failure
    fi
    echo
}


On Wed, Apr 21, 2010 at 7:56 AM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Ken,
>
> On 4/21/2010 3:07 AM, Ken Teague wrote:
>>
>> On Tue, Apr 20, 2010 at 2:13 PM, Ken Teague<kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org> =C2=A0=
wrote:
>>>
>>> I have a 17-node cluster and each node has a single IB card that ha=
s
>>> 2x IB ports (ib0 and ib1).....
>>
>> After doing a little more research, I confirmed that my understandin=
g
>> of the manual page is correct. =C2=A0To run opensm for each GUID, I
>> modified my init script to run a for loop based on the information
>> returned from "ibstat -p".
>>
>>
>> I added this near the beginning of the script where the other
>> environment variables are located:
>> <snip>
>> OFA_HOME=3D"/usr/local/sbin"
>> IBSTAT_BIN=3D"${OFA_HOME}/ibstat"
>> IBSTAT_ARG=3D"-p"
>> OPENSM_BIN=3D"${OFA_HOME}/opensm"
>> OPENSM_ARG=3D"-B -g"
>> <snip>
>>
>>
>> I replaced the single line which started opensm with this for loop:
>> for i in `${IBSTAT_BIN} ${IBSTAT_ARG}`
>> do
>> =C2=A0 =C2=A0 ${OPENSM_BIN} ${OPENSM_ARG} ${i}
>> done
>> <snip>
>>
>> If anyone has a more elegant way to handle this, I'm open to
>> suggestions. =C2=A0Many thanks.
>
> OpenSM dumps various files to /var/log and /var/cache/opensm folders.
> When you have more than one OpenSM process, they will all dump the
> same files, which is probably not a good idea.
>
> To change the output directories, set the OSM_TMP_DIR and
> OSM_CACHE_DIR env. variables to some other place.
> In addition, you need to make sure that each SM instance
> prints its log in a different place. You need to do
> something like this:
>
> foreach guid in guid_list
> =C2=A0 =C2=A0 =C2=A0 =C2=A0export OSM_TMP_DIR=3D/tmp/osm_dump_dir${gu=
id}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0export OSM_CACHE_DIR=3D/tmp/osm_dump_dir${=
guid}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0opensm --log_file /tmp/osm_dump_dir${guid}=
/osm.log -g ${guid} [your
> other options]
>
> -- Yevgeny
>
>> Ken
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
