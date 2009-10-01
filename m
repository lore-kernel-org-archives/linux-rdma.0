From: "Smith, Stan" <stan.smith@intel.com>
Subject: RE: [PATCH] typeof() not supported in Windows WDK compiler
Date: Thu, 1 Oct 2009 16:14:12 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BB5@orsmsx501.amr.corp.intel.com>
References: <DB05C7E7F5BE4BE585F311B2437350A5@amr.corp.intel.com>
	<2A3759D0AB7F46D59DF8820EFCFAF1F8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <2A3759D0AB7F46D59DF8820EFCFAF1F8@amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Hefty, Sean" <sean.hefty@intel.com>, 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
>> diff --git a/opensm/opensm/osm_drop_mgr.c
>> b/opensm/opensm/osm_drop_mgr.c index 4f98cc9..8fe5129 100644 ---
>> a/opensm/opensm/osm_drop_mgr.c +++ b/opensm/opensm/osm_drop_mgr.c
>> @@ -209,8 +209,13 @@ static void drop_mgr_remove_port(osm_sm_t * sm,
>>      IN osm_port_t * p_port) drop_mgr_clean_physp(sm, p_port->p_physp);
>>
>>      while (!cl_is_qlist_empty(&p_port->mcm_list)) {
>> +#ifndef __WIN__
>>              mcm_port =3D cl_item_obj(cl_qlist_head(&p_port->mcm_list),
>>                                     mcm_port, list_item);
>> +#else
>> +            mcm_port =3D cl_item_obj(cl_qlist_head(&p_port->mcm_list),
>> +                                   mcm_port, list_item, (osm_mcm_port_t=
*) );
>> +#endif
>
> I'd find this more readable if it were #ifdef rather than #ifndef.

So would I, although the convention is to only define something extra for W=
indows.
Perhaps a gcc/cpp defined item could be recommended and agreed upon?

>
> That said, I've got to believe that there's a better way to handle
> these changes.  I just don't know what it is.

Agreed, I'm listening.
